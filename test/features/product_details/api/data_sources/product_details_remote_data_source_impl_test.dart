import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/product_details/api/api_client/product_details_api_client.dart';
import 'package:flowers_app/features/product_details/api/data_sources/product_details_remote_data_source_impl.dart';
import 'package:flowers_app/features/product_details/data/models/product_details_response/product_details_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_details_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProductDetailsApiClient])
void main() {
  late ProductDetailsRemoteDataSourceImpl remoteDataSourceImpl;
  late MockProductDetailsApiClient mockProductDetailsApiClient;

  setUpAll(() {});

  setUp(() {
    mockProductDetailsApiClient = MockProductDetailsApiClient();

    remoteDataSourceImpl = ProductDetailsRemoteDataSourceImpl(
      mockProductDetailsApiClient,
    );
  });

  group('ProductDetailsRemoteDataSourceImpl Test', () {
    test(
      'should return SuccessBaseResponse<ProductDetailsResponse> when api call success',
      () async {
        final productDetailsResponse = ProductDetailsResponse();

        when(
          mockProductDetailsApiClient.getProductDetails('123'),
        ).thenAnswer((_) async => productDetailsResponse);

        final result = await remoteDataSourceImpl.getProductDetiles(
          productId: '123',
        );

        expect(result, isA<SuccessBaseResponse<ProductDetailsResponse>>());

        verify(mockProductDetailsApiClient.getProductDetails('123')).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse<ProductDetailsResponse> when api call fails',
      () async {
        when(
          mockProductDetailsApiClient.getProductDetails('123'),
        ).thenThrow(Exception());

        final result = await remoteDataSourceImpl.getProductDetiles(
          productId: '123',
        );

        expect(result, isA<ErrorBaseResponse<ProductDetailsResponse>>());

        verify(mockProductDetailsApiClient.getProductDetails('123')).called(1);
      },
    );
  });
}
