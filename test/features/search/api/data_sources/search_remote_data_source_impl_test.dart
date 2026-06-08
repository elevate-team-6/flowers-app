import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/models/product_model.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:flowers_app/features/search/api/api_client/search_api_client.dart';
import 'package:flowers_app/features/search/api/data_sources/search_remote_data_source_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([SearchApiClient])
void main() {
  late SearchRemoteDataSourceImpl dataSource;
  late MockSearchApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockSearchApiClient();
    dataSource = SearchRemoteDataSourceImpl(mockApiClient);
  });

  const tProductModel = ProductModel(
    id: '1',
    title: 'Rose',
    imgCover: 'https://example.com/rose.jpg',
    price: 100,
    priceAfterDiscount: 80,
    discount: 20,
    description: 'Beautiful Rose',
  );

  final tGetAllProductsResponse =
      GetAllProductsResponse(products: [tProductModel]);

  group('SearchRemoteDataSourceImpl - searchProducts', () {
    test('success: return products response', () async {
      // Arrange
      when(
        mockApiClient.searchProducts(
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => tGetAllProductsResponse);

      // Act
      final result = await dataSource.searchProducts(
        GetProductsParams(search: 'rose'),
      );

      // Assert
      expect(result, isA<SuccessBaseResponse<GetAllProductsResponse>>());
      final successResult =
          result as SuccessBaseResponse<GetAllProductsResponse>;
      expect(successResult.data, tGetAllProductsResponse);
      expect(successResult.data.products?.length, 1);
      expect(successResult.data.products?[0].title, 'Rose');
      verify(
        mockApiClient.searchProducts(
          queries: anyNamed('queries'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('success: return empty products list', () async {
      // Arrange
      const tEmptyResponse = GetAllProductsResponse(products: []);
      when(
        mockApiClient.searchProducts(
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => tEmptyResponse);

      // Act
      final result = await dataSource.searchProducts(
        GetProductsParams(search: 'xyz'),
      );

      // Assert
      expect(result, isA<SuccessBaseResponse<GetAllProductsResponse>>());
      final successResult =
          result as SuccessBaseResponse<GetAllProductsResponse>;
      expect(successResult.data.products, isEmpty);
      verify(
        mockApiClient.searchProducts(
          queries: anyNamed('queries'),
        ),
      ).called(1);
    });

    test('error: handle DioException returns ErrorBaseResponse', () async {
      // Arrange
      when(
        mockApiClient.searchProducts(
          queries: anyNamed('queries'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          message: 'Network Error',
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act
      final result = await dataSource.searchProducts(
        GetProductsParams(search: 'test'),
      );

      // Assert
      expect(result, isA<ErrorBaseResponse<GetAllProductsResponse>>());
      final errorResult = result as ErrorBaseResponse<GetAllProductsResponse>;
      expect(errorResult.errorMessage, isNotEmpty);
      verify(
        mockApiClient.searchProducts(
          queries: anyNamed('queries'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('error: handle connection timeout exception', () async {
      // Arrange
      when(
        mockApiClient.searchProducts(
          queries: anyNamed('queries'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.sendTimeout,
        ),
      );

      // Act
      final result = await dataSource.searchProducts(
        GetProductsParams(search: 'timeout_test'),
      );

      // Assert
      expect(result, isA<ErrorBaseResponse<GetAllProductsResponse>>());
    });

    test('error: handle server error (500)', () async {
      // Arrange
      when(
        mockApiClient.searchProducts(
          queries: anyNamed('queries'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 500,
            data: {'message': 'Server Error'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // Act
      final result = await dataSource.searchProducts(
        GetProductsParams(search: 'server_error'),
      );

      // Assert
      expect(result, isA<ErrorBaseResponse<GetAllProductsResponse>>());
      verify(
        mockApiClient.searchProducts(
          queries: anyNamed('queries'),
        ),
      ).called(1);
    });

    test('success: search with multiple query parameters', () async {
      // Arrange
      final tParams = GetProductsParams(search: 'rose', limit: 10);
      when(
        mockApiClient.searchProducts(
          queries: tParams.toJson(),
        ),
      ).thenAnswer((_) async => tGetAllProductsResponse);

      // Act
      final result = await dataSource.searchProducts(tParams);

      // Assert
      expect(result, isA<SuccessBaseResponse<GetAllProductsResponse>>());
      verify(
        mockApiClient.searchProducts(
          queries: tParams.toJson(),
        ),
      ).called(1);
    });
  });
}
