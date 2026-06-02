import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/core/models/product_model.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:flowers_app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:flowers_app/features/search/data/repos/search_repo_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_repo_impl_test.mocks.dart';

@GenerateMocks([SearchRemoteDataSource])
void main() {
  late SearchRepoImpl repository;
  late MockSearchRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    provideDummy<BaseResponse<GetAllProductsResponse>>(
      SuccessBaseResponse(const GetAllProductsResponse()),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockSearchRemoteDataSource();
    repository = SearchRepoImpl(mockRemoteDataSource);
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
      verify(
        mockRemoteDataSource.searchProducts(GetProductsParams(search: 'rose')),
      ).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('success: return empty list when products is null', () async {
      // Arrange
      when(
        mockRemoteDataSource.searchProducts(GetProductsParams(search: 'xyz')),
      ).thenAnswer(
        (_) async => SuccessBaseResponse(const GetAllProductsResponse()),
      );

      // Act
      final result = await repository.searchProducts(
        GetProductsParams(search: 'xyz'),
      );

      // Assert
      expect(result, isA<SuccessBaseResponse<List<ProductEntity>>>());
      final successResult = result as SuccessBaseResponse<List<ProductEntity>>;
      expect(successResult.data, []);
      verify(
        mockRemoteDataSource.searchProducts(GetProductsParams(search: 'xyz')),
      ).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
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
      verify(
        mockRemoteDataSource.searchProducts(GetProductsParams(search: 'test')),
      ).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('success: return multiple products', () async {
      // Arrange
      final tProductModel2 = ProductModel(
        id: '2',
        title: 'Tulip',
        imgCover: 'https://example.com/tulip.jpg',
        price: 80,
        priceAfterDiscount: 60,
        discount: 20,
        description: 'Beautiful Tulip',
      );
      final tMultiProductsResponse = GetAllProductsResponse(
        products: [tProductModel, tProductModel2],
      );

      when(
        mockRemoteDataSource.searchProducts(any),
      ).thenAnswer((_) async => SuccessBaseResponse(tMultiProductsResponse));

      // Act
      final result = await repository.searchProducts(
        GetProductsParams(search: 'flower'),
      );

      // Assert
      expect(result, isA<SuccessBaseResponse<List<ProductEntity>>>());
      final successResult = result as SuccessBaseResponse<List<ProductEntity>>;
      expect(successResult.data.length, 2);
      expect(successResult.data[0].title, 'Rose');
      expect(successResult.data[1].title, 'Tulip');
      verify(mockRemoteDataSource.searchProducts(any)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
