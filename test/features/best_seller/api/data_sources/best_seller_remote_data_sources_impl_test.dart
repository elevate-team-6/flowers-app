import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/best_seller/api/api_client/best_seller_api_client.dart';
import 'package:flowers_app/features/best_seller/api/data_sources/best_seller_remote_data_source_impl.dart';
import 'package:flowers_app/features/best_seller/data/models/best_seller_products_response/best_seller_products_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'best_seller_remote_data_sources_impl_test.mocks.dart';

@GenerateMocks([BestSellerApiClient])
void main() {
  late MockBestSellerApiClient mockBestSellerApiClient;

  late BestSellerRemoteDataSourceImpl bestSellerRemoteDataSource;

  setUp(() {
    mockBestSellerApiClient = MockBestSellerApiClient();

    bestSellerRemoteDataSource = BestSellerRemoteDataSourceImpl(
      mockBestSellerApiClient,
    );
  });

  group('Best Seller Remote Data Source Tests', () {
    test('should return SuccessBaseResponse when api call succeeds', () async {
      final response = BestSellerProductsResponse();

      when(
        mockBestSellerApiClient.bestSeller(),
      ).thenAnswer((_) async => response);

      final result = await bestSellerRemoteDataSource.bestSeller();

      expect(result, isA<SuccessBaseResponse<BestSellerProductsResponse>>());

      verify(mockBestSellerApiClient.bestSeller()).called(1);
    });

    test(
      'should return ErrorBaseResponse when api throws DioException',
      () async {
        when(
          mockBestSellerApiClient.bestSeller(),
        ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

        final result = await bestSellerRemoteDataSource.bestSeller();

        expect(result, isA<ErrorBaseResponse<BestSellerProductsResponse>>());

        verify(mockBestSellerApiClient.bestSeller()).called(1);
      },
    );
  });
}
