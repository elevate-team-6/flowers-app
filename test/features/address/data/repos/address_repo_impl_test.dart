import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/data/data_sources/address_local_data_source_contract.dart';
import 'package:flowers_app/features/address/data/data_sources/address_remote_data_source_contract.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';
import 'package:flowers_app/features/address/data/models/address_response.dart';
import 'package:flowers_app/features/address/data/repos/address_repo_impl.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_repo_impl_test.mocks.dart';

@GenerateMocks([
  AddressRemoteDataSourceContract,
  AddressLocalDataSourceContract,
])
void main() {
  late AddressRepoImpl repository;
  late MockAddressRemoteDataSourceContract mockRemoteDataSource;
  late MockAddressLocalDataSourceContract mockLocalDataSource;

  const tAddressModel = AddressModel(
    id: '1',
    username: 'John Doe',
    phone: '0123456789',
    street: 'Maadi | Road 9',
    city: 'Cairo',
    lat: '30.0444',
    long: '31.2357',
  );

  const tAddressEntity = AddressEntity(
    id: '1',
    recipientName: 'John Doe',
    phoneNumber: '0123456789',
    street: 'Road 9',
    area: 'Maadi',
    city: 'Cairo',
    latitude: '30.0444',
    longitude: '31.2357',
    isDefault: true,
  );

  setUpAll(() {
    provideDummy<BaseResponse<AddressResponse>>(
      SuccessBaseResponse(AddressResponse(addresses: [])),
    );
    provideDummy<BaseResponse<AddressModel?>>(SuccessBaseResponse(null));
  });

  setUp(() {
    mockRemoteDataSource = MockAddressRemoteDataSourceContract();
    mockLocalDataSource = MockAddressLocalDataSourceContract();
    repository = AddressRepoImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('Address Repository Implementation Tests', () {
    group('getAddresses', () {
      test(
        'should return mapped and synced address list when remote data source succeeds',
        () async {
          // Arrange
          when(mockRemoteDataSource.getAddresses()).thenAnswer(
            (_) async => SuccessBaseResponse(
              AddressResponse(addresses: [tAddressModel]),
            ),
          );
          when(
            mockRemoteDataSource.getDefaultAddress(),
          ).thenAnswer((_) async => SuccessBaseResponse(tAddressModel));

          // Act
          final result = await repository.getAddresses();

          // Assert
          expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
          final data =
              (result as SuccessBaseResponse<List<AddressEntity>>).data;
          expect(data.length, 1);
          expect(data[0].area, 'Maadi');
          expect(data[0].street, 'Road 9');
          expect(data[0].isDefault, true);
          verify(mockRemoteDataSource.getAddresses()).called(1);
          verify(mockRemoteDataSource.getDefaultAddress()).called(1);
        },
      );

      test(
        'should handle address without delimiter by setting area as empty string',
        () async {
          // Arrange
          const noDelimiterModel = AddressModel(
            id: '2',
            username: 'Jane',
            street: 'Just Street',
            city: 'Alex',
          );
          when(mockRemoteDataSource.getAddresses()).thenAnswer(
            (_) async => SuccessBaseResponse(
              AddressResponse(addresses: [noDelimiterModel]),
            ),
          );
          when(
            mockRemoteDataSource.getDefaultAddress(),
          ).thenAnswer((_) async => SuccessBaseResponse(null));

          // Act
          final result = await repository.getAddresses();

          // Assert
          final data =
              (result as SuccessBaseResponse<List<AddressEntity>>).data;
          expect(data[0].area, '');
          expect(data[0].street, 'Just Street');
          expect(data[0].isDefault, false);
        },
      );

      test(
        'should handle address with multiple delimiters by taking first part as area and rest as street',
        () async {
          // Arrange
          const multiDelimiterModel = AddressModel(
            id: '3',
            username: 'Bob',
            street: 'Area Part | Street Part | Extra Info',
            city: 'Giza',
          );
          when(mockRemoteDataSource.getAddresses()).thenAnswer(
            (_) async => SuccessBaseResponse(
              AddressResponse(addresses: [multiDelimiterModel]),
            ),
          );
          when(
            mockRemoteDataSource.getDefaultAddress(),
          ).thenAnswer((_) async => SuccessBaseResponse(null));

          // Act
          final result = await repository.getAddresses();

          // Assert
          final data =
              (result as SuccessBaseResponse<List<AddressEntity>>).data;
          expect(data[0].area, 'Area Part');
          expect(data[0].street, 'Street Part | Extra Info');
        },
      );

      test(
        'should set isDefault to false for all items if default address ID does not match any address',
        () async {
          // Arrange
          when(mockRemoteDataSource.getAddresses()).thenAnswer(
            (_) async => SuccessBaseResponse(
              AddressResponse(addresses: [tAddressModel]),
            ),
          );
          when(mockRemoteDataSource.getDefaultAddress()).thenAnswer(
            (_) async =>
                SuccessBaseResponse(const AddressModel(id: 'non-existent-id')),
          );

          // Act
          final result = await repository.getAddresses();

          // Assert
          final data =
              (result as SuccessBaseResponse<List<AddressEntity>>).data;
          expect(data[0].isDefault, false);
        },
      );

      test(
        'should return ErrorBaseResponse when remote data source fails',
        () async {
          // Arrange
          when(
            mockRemoteDataSource.getAddresses(),
          ).thenAnswer((_) async => ErrorBaseResponse('Network Error'));

          // Act
          final result = await repository.getAddresses();

          // Assert
          expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
          expect((result as ErrorBaseResponse).errorMessage, 'Network Error');
        },
      );
    });

    group('addAddress', () {
      test(
        'should join area and street using delimiter before calling remote data source',
        () async {
          // Arrange
          when(mockRemoteDataSource.addAddress(any)).thenAnswer(
            (_) async => SuccessBaseResponse(
              AddressResponse(addresses: [tAddressModel]),
            ),
          );
          when(
            mockRemoteDataSource.getDefaultAddress(),
          ).thenAnswer((_) async => SuccessBaseResponse(null));

          // Act
          await repository.addAddress(tAddressEntity);

          // Assert
          final captured =
              verify(
                    mockRemoteDataSource.addAddress(captureAny),
                  ).captured.single
                  as AddressModel;
          expect(captured.street, 'Maadi | Road 9');
        },
      );
    });

    group('deleteAddress', () {
      test('should call remote data source and return success', () async {
        // Arrange
        when(mockRemoteDataSource.deleteAddress(any)).thenAnswer(
          (_) async => SuccessBaseResponse(AddressResponse(addresses: [])),
        );
        when(
          mockRemoteDataSource.getDefaultAddress(),
        ).thenAnswer((_) async => SuccessBaseResponse(null));

        // Act
        final result = await repository.deleteAddress('1');

        // Assert
        expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
        verify(mockRemoteDataSource.deleteAddress('1')).called(1);
        verify(mockRemoteDataSource.getDefaultAddress()).called(1);
      });
    });
  });
}
