import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/core/models/product_model.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:flowers_app/features/search/data/data_sources/search_local_data_source.dart';
import 'package:flowers_app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:flowers_app/features/search/data/repos/search_repo_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_repo_impl_test.mocks.dart';

@GenerateMocks([SearchRemoteDataSource, SearchLocalDataSource])
void main() {
  late SearchRepoImpl repository;
  late MockSearchRemoteDataSource mockRemoteDataSource;
  late MockSearchLocalDataSource mockLocalDataSource;

  setUpAll(() {
    provideDummy<BaseResponse<GetAllProductsResponse>>(
      SuccessBaseResponse(const GetAllProductsResponse()),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockSearchRemoteDataSource();
    mockLocalDataSource = MockSearchLocalDataSource();
    repository = SearchRepoImpl(mockRemoteDataSource, mockLocalDataSource);
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

  const tProductEntity = ProductEntity(
    id: '1',
    title: 'Rose',
    imgCover: 'https://example.com/rose.jpg',
    price: 100,
    priceAfterDiscount: 80,
    discount: 20,
    description: 'Beautiful Rose',
  );

  final tGetAllProductsResponse = GetAllProductsResponse(
    products: [tProductModel],
  );

  group('SearchRepoImpl - searchProducts', () {
    test('success: return products when data source succeeds', () async {
      // Arrange
      when(
        mockRemoteDataSource.searchProducts(GetProductsParams(search: 'rose')),
      ).thenAnswer((_) async => SuccessBaseResponse(tGetAllProductsResponse));

      // Act
      final result = await repository.searchProducts(
        GetProductsParams(search: 'rose'),
      );

      // Assert
      expect(result, isA<SuccessBaseResponse<List<ProductEntity>>>());
      final successResult = result as SuccessBaseResponse<List<ProductEntity>>;
      expect(successResult.data.length, 1);
      expect(successResult.data[0], tProductEntity);
    });

    test('error: return error when data source fails', () async {
      // Arrange
      const errorMessage = 'Network Error';
      when(
        mockRemoteDataSource.searchProducts(GetProductsParams(search: 'test')),
      ).thenAnswer(
        (_) async => ErrorBaseResponse<GetAllProductsResponse>(errorMessage),
      );

      // Act
      final result = await repository.searchProducts(
        GetProductsParams(search: 'test'),
      );

      // Assert
      expect(result, isA<ErrorBaseResponse<List<ProductEntity>>>());
      final errorResult = result as ErrorBaseResponse<List<ProductEntity>>;
      expect(errorResult.errorMessage, errorMessage);
    });
  });

  group('SearchRepoImpl - History Management', () {
    test('getSearchHistory: call local data source', () async {
      // Arrange
      final tHistory = ['rose', 'tulip'];
      when(
        mockLocalDataSource.getSearchHistory(),
      ).thenAnswer((_) async => tHistory);

      // Act
      final result = await repository.getSearchHistory();

      // Assert
      expect(result, tHistory);
      verify(mockLocalDataSource.getSearchHistory()).called(1);
    });

    test('saveSearchHistory: call local data source', () async {
      // Arrange
      final tHistory = ['rose'];
      when(mockLocalDataSource.saveSearchHistory(any)).thenAnswer((_) async {});

      // Act
      await repository.saveSearchHistory(tHistory);

      // Assert
      verify(mockLocalDataSource.saveSearchHistory(tHistory)).called(1);
    });

    test('clearSearchHistory: call local data source', () async {
      // Arrange
      when(mockLocalDataSource.clearSearchHistory()).thenAnswer((_) async {});

      // Act
      await repository.clearSearchHistory();

      // Assert
      verify(mockLocalDataSource.clearSearchHistory()).called(1);
    });
  });
}
