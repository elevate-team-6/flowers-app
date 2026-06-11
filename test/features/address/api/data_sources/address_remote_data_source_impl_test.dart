import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/api/api_client/address_api_client.dart';
import 'package:flowers_app/features/address/api/data_sources/address_remote_data_source_impl.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';
import 'package:flowers_app/features/address/data/models/address_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AddressApiClient])
void main() {
  late AddressRemoteDataSourceImpl dataSource;
  late MockAddressApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockAddressApiClient();
    dataSource = AddressRemoteDataSourceImpl(mockApiClient);
  });

  const tAddressModel = AddressModel(
    id: '1',
    username: 'John',
    phone: '0123',
    street: 'Street',
    city: 'City',
    lat: '0',
    long: '0',
  );

  final tAddressResponse = AddressResponse(addresses: [tAddressModel]);

  group('Address Remote Data Source Tests', () {
    group('getAddresses', () {
      test(
        'should return SuccessBaseResponse when API call is successful',
        () async {
          when(
            mockApiClient.getAddresses(),
          ).thenAnswer((_) async => tAddressResponse);

          final result = await dataSource.getAddresses();

          expect(result, isA<SuccessBaseResponse<AddressResponse>>());
          expect((result as SuccessBaseResponse).data, tAddressResponse);
          verify(mockApiClient.getAddresses()).called(1);
        },
      );

      test(
        'should return ErrorBaseResponse when API call throws DioException',
        () async {
          when(mockApiClient.getAddresses()).thenThrow(
            DioException(
              requestOptions: RequestOptions(),
              error: 'Network Error',
              type: DioExceptionType.connectionError,
            ),
          );

          final result = await dataSource.getAddresses();

          expect(result, isA<ErrorBaseResponse<AddressResponse>>());
          expect((result as ErrorBaseResponse).errorMessage, isNotNull);
        },
      );
    });

    group('addAddress', () {
      test('should call add API and return success response', () async {
        when(
          mockApiClient.addAddress(any),
        ).thenAnswer((_) async => tAddressResponse);

        final result = await dataSource.addAddress(tAddressModel);

        expect(result, isA<SuccessBaseResponse<AddressResponse>>());
        verify(mockApiClient.addAddress(tAddressModel)).called(1);
      });
    });

    group('updateAddress', () {
      test('should call update API and return success response', () async {
        when(
          mockApiClient.updateAddress(any, any),
        ).thenAnswer((_) async => tAddressResponse);

        final result = await dataSource.updateAddress(tAddressModel);

        expect(result, isA<SuccessBaseResponse<AddressResponse>>());
        verify(mockApiClient.updateAddress('1', tAddressModel)).called(1);
      });

      test('should return error when address model ID is null', () async {
        const noIdModel = AddressModel(username: 'John');
        final result = await dataSource.updateAddress(noIdModel);

        expect(result, isA<ErrorBaseResponse<AddressResponse>>());
        verifyNever(mockApiClient.updateAddress(any, any));
      });
    });

    group('deleteAddress', () {
      test('should call delete API and return success response', () async {
        when(
          mockApiClient.deleteAddress(any),
        ).thenAnswer((_) async => tAddressResponse);

        final result = await dataSource.deleteAddress('1');

        expect(result, isA<SuccessBaseResponse<AddressResponse>>());
        verify(mockApiClient.deleteAddress('1')).called(1);
      });
    });
  });
}
