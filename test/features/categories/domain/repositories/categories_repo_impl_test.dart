import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/core/models/product_model.dart';
import 'package:flowers_app/features/categories/data/data_sources/categories_remote_data_source_impl.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/data/models/response/category_model.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_categories_response.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';
import 'package:flowers_app/features/categories/domain/repositories/categories_repo_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'categories_repo_impl_test.mocks.dart';

@GenerateMocks([CategoriesRemoteDataSourceImpl])
void main() {
  late CategoriesRepoImpl repoImpl;
  late MockCategoriesRemoteDataSourceImpl mockRemoteDataSource;
  late GetAllCategoriesResponse getAllCategoriesResponse;
  late GetAllProductsResponse getAllProductsResponse;
  late List<CategoryModel> responseCategories;
  late List<ProductModel> responseProducts;
  late String errorMassage;

  setUpAll(() {
    responseCategories = List.generate(
      5,
      (index) => CategoryModel(
        id: index.toString(),
        name: "Category $index",
        slug: "category-$index",
        image: "https://example.com/category-image-$index.jpg",
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      ),
    );
    responseProducts = List.generate(
      5,
      (index) => ProductModel(
        id: index.toString(),
        title: "Product $index",
        slug: "product-$index",
        description: "Description of product $index",
        imgCover: "https://example.com/product-cover-$index.jpg",
        images: ["https://example.com/product-image-$index-1.jpg"],
        price: 100 * index,
        priceAfterDiscount: 90 * index,
        discount: 10 * index,
        rateAvg: 4.5,
        rateCount: 100,
        sold: 1000 * index,
        quantity: 1000 * index,
        category: "Category $index",
        occasion: "Occasion $index",
        isSuperAdmin: false,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        favoriteId: null,
        isInWishlist: false,
      ),
    );
    getAllProductsResponse = GetAllProductsResponse(products: responseProducts);
    getAllCategoriesResponse = GetAllCategoriesResponse(
      categories: responseCategories,
    );
    errorMassage = "Error massage";
    provideDummy<BaseResponse<GetAllCategoriesResponse>>(
      SuccessBaseResponse<GetAllCategoriesResponse>(getAllCategoriesResponse),
    );
    provideDummy<BaseResponse<GetAllProductsResponse>>(
      SuccessBaseResponse<GetAllProductsResponse>(getAllProductsResponse),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockCategoriesRemoteDataSourceImpl();
    repoImpl = CategoriesRepoImpl(mockRemoteDataSource);
  });

  group('getCategories', () {
    group('success', () {
      test("Test Success Case with null categories", () async {
        when(mockRemoteDataSource.getCategories()).thenAnswer(
          (_) async => SuccessBaseResponse<GetAllCategoriesResponse>(
            GetAllCategoriesResponse(categories: null),
          ),
        );

        final result = await repoImpl.getCategories();

        expect(result, isA<SuccessBaseResponse<List<CategoryEntity>>>());
        expect(
          (result as SuccessBaseResponse<List<CategoryEntity>>).data,
          isEmpty,
        );
        verify(mockRemoteDataSource.getCategories()).called(1);
      });
      test("Test Success Case with empty categories", () async {
        when(mockRemoteDataSource.getCategories()).thenAnswer(
          (_) async => SuccessBaseResponse<GetAllCategoriesResponse>(
            GetAllCategoriesResponse(categories: []),
          ),
        );

        final result = await repoImpl.getCategories();

        expect(result, isA<SuccessBaseResponse<List<CategoryEntity>>>());
        expect(
          (result as SuccessBaseResponse<List<CategoryEntity>>).data.length,
          0,
        );
        verify(mockRemoteDataSource.getCategories()).called(1);
      });
      test("Test Success Case with non-empty categories", () async {
        when(mockRemoteDataSource.getCategories()).thenAnswer(
          (_) async => SuccessBaseResponse<GetAllCategoriesResponse>(
            getAllCategoriesResponse,
          ),
        );

        final result = await repoImpl.getCategories();

        expect(result, isA<SuccessBaseResponse<List<CategoryEntity>>>());
        expect(
          (result as SuccessBaseResponse<List<CategoryEntity>>).data.length,
          responseCategories.length,
        );
        verify(mockRemoteDataSource.getCategories()).called(1);

        expect(result.data[0].id, responseCategories[0].id);
        expect(result.data[0].name, responseCategories[0].name);
        expect(result.data[0].image, responseCategories[0].image);

        expect(result.data.last.id, responseCategories.last.id);
        expect(result.data.last.name, responseCategories.last.name);
        expect(result.data.last.image, responseCategories.last.image);
      });
    });
    group('error', () {
      test("Test Error Case", () async {
        when(mockRemoteDataSource.getCategories()).thenAnswer(
          (_) async =>
              ErrorBaseResponse<GetAllCategoriesResponse>(errorMassage),
        );

        final result = await repoImpl.getCategories();

        expect(result, isA<ErrorBaseResponse<List<CategoryEntity>>>());
        expect(
          (result as ErrorBaseResponse<List<CategoryEntity>>).errorMessage,
          errorMassage,
        );
        expect(result.errorMessage, isNotNull);
        verify(mockRemoteDataSource.getCategories()).called(1);
      });
    });
  });

  group('getProducts', () {
    group('success', () {
      test("Test Success Case with null products", () async {
        when(mockRemoteDataSource.getProducts(any)).thenAnswer(
          (_) async => SuccessBaseResponse<GetAllProductsResponse>(
            GetAllProductsResponse(products: null),
          ),
        );

        final result = await repoImpl.getProducts(
          GetProductsParams(category: null, search: null, sort: null),
        );

        expect(result, isA<SuccessBaseResponse<List<ProductEntity>>>());
        expect(
          (result as SuccessBaseResponse<List<ProductEntity>>).data,
          isEmpty,
        );
        verify(mockRemoteDataSource.getProducts(any)).called(1);
      });
      test("Test Success Case with empty products", () async {
        when(mockRemoteDataSource.getProducts(any)).thenAnswer(
          (_) async => SuccessBaseResponse<GetAllProductsResponse>(
            GetAllProductsResponse(products: []),
          ),
        );

        final result = await repoImpl.getProducts(
          GetProductsParams(category: null, search: null, sort: null),
        );

        expect(result, isA<SuccessBaseResponse<List<ProductEntity>>>());
        expect(
          (result as SuccessBaseResponse<List<ProductEntity>>).data,
          isEmpty,
        );
        verify(mockRemoteDataSource.getProducts(any)).called(1);
      });
      test("Test Success Case with non-empty products", () async {
        when(mockRemoteDataSource.getProducts(any)).thenAnswer(
          (_) async => SuccessBaseResponse<GetAllProductsResponse>(
            GetAllProductsResponse(products: responseProducts),
          ),
        );

        final result = await repoImpl.getProducts(
          GetProductsParams(category: null, search: null, sort: null),
        );

        expect(result, isA<SuccessBaseResponse<List<ProductEntity>>>());
        expect(
          (result as SuccessBaseResponse<List<ProductEntity>>).data,
          isNotEmpty,
        );
        expect((result).data.length, responseProducts.length);
        verify(mockRemoteDataSource.getProducts(any)).called(1);

        expect(result.data[0].id, responseProducts[0].id);
        expect(result.data[0].title, responseProducts[0].title);
        expect(result.data[0].imgCover, responseProducts[0].imgCover);
        expect(result.data[0].discount, responseProducts[0].discount);
        expect(result.data[0].price, responseProducts[0].price);
        expect(
          result.data[0].priceAfterDiscount,
          responseProducts[0].priceAfterDiscount,
        );

        expect(result.data.last.id, responseProducts.last.id);
        expect(result.data.last.title, responseProducts.last.title);
        expect(result.data.last.imgCover, responseProducts.last.imgCover);
        expect(result.data.last.discount, responseProducts.last.discount);
        expect(result.data.last.price, responseProducts.last.price);
        expect(
          result.data.last.priceAfterDiscount,
          responseProducts.last.priceAfterDiscount,
        );
      });
    });
    group('error', () {
      test("Test Error Case", () async {
        when(mockRemoteDataSource.getProducts(any)).thenAnswer(
          (_) async => ErrorBaseResponse<GetAllProductsResponse>(errorMassage),
        );

        final result = await repoImpl.getProducts(
          GetProductsParams(category: null, search: null, sort: null),
        );

        expect(result, isA<ErrorBaseResponse<List<ProductEntity>>>());
        expect(
          (result as ErrorBaseResponse<List<ProductEntity>>).errorMessage,
          errorMassage,
        );
        expect(result.errorMessage, isNotNull);
        verify(mockRemoteDataSource.getProducts(any)).called(1);
      });
    });
  });
}
