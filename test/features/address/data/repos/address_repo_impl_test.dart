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
  );

  setUpAll(() {
    provideDummy<BaseResponse<AddressResponse>>(
      SuccessBaseResponse(AddressResponse(addresses: [])),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockAddressRemoteDataSourceContract();
    mockLocalDataSource = MockAddressLocalDataSourceContract();
    repository = AddressRepoImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('Address Repository Implementation Tests', () {
    group('getAddresses', () {
      test(
        'should return mapped address list when remote data source succeeds',
        () async {
          // Arrange
          when(mockRemoteDataSource.getAddresses()).thenAnswer(
            (_) async => SuccessBaseResponse(
              AddressResponse(addresses: [tAddressModel]),
            ),
          );

          // Act
          final result = await repository.getAddresses();

          // Assert
          expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
          final data =
              (result as SuccessBaseResponse<List<AddressEntity>>).data;
          expect(data.length, 1);
          expect(data[0].id, '1');
          expect(data[0].city, 'Cairo');
          verify(mockRemoteDataSource.getAddresses()).called(1);
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
      test('should call remote data source and return success', () async {
        // Arrange
        when(mockRemoteDataSource.addAddress(any)).thenAnswer(
          (_) async =>
              SuccessBaseResponse(AddressResponse(addresses: [tAddressModel])),
        );

        // Act
        final result = await repository.addAddress(tAddressEntity);

        // Assert
        expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
        verify(mockRemoteDataSource.addAddress(any)).called(1);
      });
    });

    group('updateAddress', () {
      test('should call remote data source and return success', () async {
        // Arrange
        when(mockRemoteDataSource.updateAddress(any)).thenAnswer(
          (_) async =>
              SuccessBaseResponse(AddressResponse(addresses: [tAddressModel])),
        );

        // Act
        final result = await repository.updateAddress(tAddressEntity);

        // Assert
        expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
        verify(mockRemoteDataSource.updateAddress(any)).called(1);
      });
    });

    group('deleteAddress', () {
      test('should call remote data source and return success', () async {
        // Arrange
        when(mockRemoteDataSource.deleteAddress(any)).thenAnswer(
          (_) async => SuccessBaseResponse(AddressResponse(addresses: [])),
        );

        // Act
        final result = await repository.deleteAddress('1');

        // Assert
        expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
        verify(mockRemoteDataSource.deleteAddress('1')).called(1);
      });
    });
  });
}
