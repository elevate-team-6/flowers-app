import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/models/product_model.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/categories/api/api_client/categories_api_client.dart';
import 'package:flowers_app/features/categories/data/data_sources/categories_remote_data_source_impl.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/data/models/response/category_model.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_categories_response.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'categories_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CategoriesApiClient])
void main() {
  late CategoriesRemoteDataSourceImpl dataSourceImpl;
  late MockCategoriesApiClient mockApiClient;
  late GetAllCategoriesResponse getAllCategoriesResponse;
  late GetAllProductsResponse getAllProductsResponse;
  late List<CategoryModel> responseCategories;
  late List<ProductModel> responseProducts;

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
    provideDummy<BaseResponse>(
      SuccessBaseResponse<GetAllCategoriesResponse>(getAllCategoriesResponse),
    );
    provideDummy<BaseResponse>(
      SuccessBaseResponse<GetAllProductsResponse>(getAllProductsResponse),
    );
  });

  setUp(() {
    mockApiClient = MockCategoriesApiClient();
    dataSourceImpl = CategoriesRemoteDataSourceImpl(mockApiClient);
  });

  group("getCategories", () {
    group("success", () {
      test("Test Success Case with empty categories", () async {
        when(
          mockApiClient.getCategories(),
        ).thenAnswer((_) async => GetAllCategoriesResponse(categories: []));

        final result = await dataSourceImpl.getCategories();
        expect(result, isA<SuccessBaseResponse<GetAllCategoriesResponse>>());
        expect(
          (result as SuccessBaseResponse<GetAllCategoriesResponse>)
              .data
              .categories,
          isEmpty,
        );
        verify(mockApiClient.getCategories()).called(1);
      });

      test("Test Success Case with non-empty categories", () async {
        when(
          mockApiClient.getCategories(),
        ).thenAnswer((_) async => getAllCategoriesResponse);

        final result = await dataSourceImpl.getCategories();
        expect(result, isA<SuccessBaseResponse<GetAllCategoriesResponse>>());
        expect(
          (result as SuccessBaseResponse<GetAllCategoriesResponse>)
              .data
              .categories,
          isNotEmpty,
        );
        expect((result).data.categories, isNotNull);
        expect((result).data.categories?.length, responseCategories.length);
        verify(mockApiClient.getCategories()).called(1);

        expect(result.data.categories?[0].id, responseCategories[0].id);
        expect(result.data.categories?[0].name, responseCategories[0].name);
        expect(result.data.categories?[0].image, responseCategories[0].image);

        expect(result.data.categories?.last.id, responseCategories.last.id);
        expect(result.data.categories?.last.name, responseCategories.last.name);
        expect(
          result.data.categories?.last.image,
          responseCategories.last.image,
        );
      });
    });
    test("Test Error Case", () async {
      when(mockApiClient.getCategories()).thenThrow(Exception("any error"));

      final result = await dataSourceImpl.getCategories();
      expect(result, isA<ErrorBaseResponse<GetAllCategoriesResponse>>());
      expect(
        (result as ErrorBaseResponse<GetAllCategoriesResponse>).errorMessage,
        AppStrings.unknownError,
      );
      expect(result.errorMessage, isNotNull);
      verify(mockApiClient.getCategories()).called(1);
    });
  });

  group("getProducts", () {
    group("success", () {
      test("Test Success Case with empty products", () async {
        when(
          mockApiClient.getProducts(queries: anyNamed('queries')),
        ).thenAnswer((_) async => GetAllProductsResponse(products: []));

        final result = await dataSourceImpl.getProducts(GetProductsParams());
        expect(result, isA<SuccessBaseResponse<GetAllProductsResponse>>());
        expect(
          (result as SuccessBaseResponse<GetAllProductsResponse>).data.products,
          isEmpty,
        );
        verify(
          mockApiClient.getProducts(queries: anyNamed('queries')),
        ).called(1);
      });
      test("Test Success Case with non-empty products", () async {
        when(
          mockApiClient.getProducts(queries: anyNamed('queries')),
        ).thenAnswer((_) async => getAllProductsResponse);

        final result = await dataSourceImpl.getProducts(GetProductsParams());
        expect(result, isA<SuccessBaseResponse<GetAllProductsResponse>>());
        expect(
          (result as SuccessBaseResponse<GetAllProductsResponse>).data.products,
          isNotEmpty,
        );
        expect((result).data.products, isNotNull);
        expect((result).data.products?.length, responseProducts.length);
        verify(
          mockApiClient.getProducts(queries: anyNamed('queries')),
        ).called(1);

        expect(result.data.products?[0].id, responseProducts[0].id);
        expect(result.data.products?[0].title, responseProducts[0].title);
        expect(result.data.products?[0].imgCover, responseProducts[0].imgCover);
        expect(result.data.products?[0].discount, responseProducts[0].discount);
        expect(result.data.products?[0].price, responseProducts[0].price);
        expect(
          result.data.products?[0].priceAfterDiscount,
          responseProducts[0].priceAfterDiscount,
        );

        expect(result.data.products?.last.id, responseProducts.last.id);
        expect(result.data.products?.last.title, responseProducts.last.title);
        expect(
          result.data.products?.last.imgCover,
          responseProducts.last.imgCover,
        );
        expect(
          result.data.products?.last.discount,
          responseProducts.last.discount,
        );
        expect(result.data.products?.last.price, responseProducts.last.price);
        expect(
          result.data.products?.last.priceAfterDiscount,
          responseProducts.last.priceAfterDiscount,
        );
      });
    });

    group("error", () {
      test("Test Error Case with general exception", () async {
        when(
          mockApiClient.getProducts(queries: anyNamed('queries')),
        ).thenThrow(Exception("any error"));

        final result = await dataSourceImpl.getProducts(GetProductsParams());
        expect(result, isA<ErrorBaseResponse<GetAllProductsResponse>>());
        expect(
          (result as ErrorBaseResponse<GetAllProductsResponse>).errorMessage,
          AppStrings.unknownError,
        );
        verify(
          mockApiClient.getProducts(queries: anyNamed('queries')),
        ).called(1);
      });
      group("Test Error Case with DioException", () {
        test("Test Connection Timeout", () async {
          when(
            mockApiClient.getProducts(queries: anyNamed('queries')),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.connectionTimeout,
            ),
          );

          final result = await dataSourceImpl.getProducts(GetProductsParams());
          expect(result, isA<ErrorBaseResponse<GetAllProductsResponse>>());
          expect(
            (result as ErrorBaseResponse<GetAllProductsResponse>).errorMessage,
            AppStrings.connectionTimeout,
          );
          verify(
            mockApiClient.getProducts(queries: anyNamed('queries')),
          ).called(1);
        });
        test("Test connection error", () async {
          when(
            mockApiClient.getProducts(queries: anyNamed('queries')),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.connectionError,
            ),
          );

          final result = await dataSourceImpl.getProducts(GetProductsParams());

          expect(result, isA<ErrorBaseResponse<GetAllProductsResponse>>());
          expect(
            (result as ErrorBaseResponse<GetAllProductsResponse>).errorMessage,
            AppStrings.noInternetConnection,
          );
          verify(
            mockApiClient.getProducts(queries: anyNamed('queries')),
          ).called(1);
        });
      });
    });
  });
}
