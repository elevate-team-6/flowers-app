import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';
import 'package:flowers_app/features/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flowers_app/features/categories/domain/use_cases/get_products_use_case.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_cubit.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_event.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'categories_cubit_test.mocks.dart';

@GenerateMocks([GetCategoriesUseCase, GetProductsUseCase])
void main() {
  late CategoriesCubit categoriesCubit;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;

  late List<CategoryEntity> responseCategories;
  late List<ProductEntity> responseProducts;
  late String errorMassage;

  setUpAll(() {
    responseCategories = List.generate(
      5,
      (index) => CategoryEntity(
        id: index.toString(),
        name: "Category $index",
        image: "https://example.com/category-image-$index.jpg",
      ),
    );
    responseProducts = List.generate(
      5,
      (index) => ProductEntity(
        id: index.toString(),
        title: "Product $index",
        imgCover: "https://example.com/product-cover-$index.jpg",
        price: 100 * index,
        priceAfterDiscount: 90 * index,
        discount: 10 * index,
      ),
    );
    errorMassage = "Error massage";
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessBaseResponse<List<CategoryEntity>>(responseCategories),
    );
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessBaseResponse<List<ProductEntity>>(responseProducts),
    );
  });

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetProductsUseCase = MockGetProductsUseCase();
    categoriesCubit = CategoriesCubit(
      mockGetCategoriesUseCase,
      mockGetProductsUseCase,
    );
  });

  group('getCategories', () {
    group('success', () {
      blocTest<CategoriesCubit, CategoriesStates>(
        "Test Success Case with empty categories",
        build: () {
          when(mockGetCategoriesUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<CategoryEntity>>([]),
          );
          return categoriesCubit;
        },

        act: (cubit) => cubit.doEvent(GetCategoriesRequestedEvent()),

        expect: () => [
          CategoriesStates(
            categoriesState: const BaseState<List<CategoryEntity>>(
              isLoading: true,
            ),
          ),
          CategoriesStates(
            categoriesState: BaseState<List<CategoryEntity>>(
              isLoading: false,
              data: [],
            ),
          ),
        ],

        verify: (_) {
          verify(mockGetCategoriesUseCase()).called(1);
        },
      );

      blocTest<CategoriesCubit, CategoriesStates>(
        "Test Success Case with non-empty categories",
        build: () {
          when(mockGetCategoriesUseCase()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<CategoryEntity>>(responseCategories),
          );
          return categoriesCubit;
        },

        act: (cubit) => cubit.doEvent(GetCategoriesRequestedEvent()),

        expect: () => [
          CategoriesStates(
            categoriesState: const BaseState<List<CategoryEntity>>(
              isLoading: true,
            ),
          ),
          CategoriesStates(
            categoriesState: BaseState<List<CategoryEntity>>(
              isLoading: false,
              data: responseCategories,
            ),
          ),
        ],

        verify: (_) => verify(mockGetCategoriesUseCase()).called(1),
      );
    });
    group('error', () {
      blocTest<CategoriesCubit, CategoriesStates>(
        "Test Error Case",
        build: () {
          when(mockGetCategoriesUseCase()).thenAnswer(
            (_) async => ErrorBaseResponse<List<CategoryEntity>>(errorMassage),
          );
          return categoriesCubit;
        },

        act: (cubit) => cubit.doEvent(GetCategoriesRequestedEvent()),

        expect: () => [
          CategoriesStates(
            categoriesState: const BaseState<List<CategoryEntity>>(
              isLoading: true,
            ),
          ),
          CategoriesStates(
            categoriesState: BaseState<List<CategoryEntity>>(
              isLoading: false,
              errorMessage: errorMassage,
            ),
          ),
        ],

        verify: (_) => verify(mockGetCategoriesUseCase()).called(1),
      );
    });
  });

  group('getProducts', () {
    group('success', () {
      blocTest<CategoriesCubit, CategoriesStates>(
        "Test Success Case with empty products",
        build: () {
          when(
            mockGetProductsUseCase.call(
              params: GetProductsParams(
                category: null,
                search: null,
                sort: null,
              ),
            ),
          ).thenAnswer(
            (_) async => SuccessBaseResponse<List<ProductEntity>>([]),
          );
          return categoriesCubit;
        },

        act: (cubit) => cubit.doEvent(GetProductsRequestedEvent()),

        expect: () => [
          CategoriesStates(productsState: const BaseState(isLoading: true)),
          CategoriesStates(
            productsState: BaseState(isLoading: false, data: []),
          ),
        ],

        verify: (_) => verify(
          mockGetProductsUseCase.call(
            params: GetProductsParams(category: null, search: null, sort: null),
          ),
        ).called(1),
      );

      blocTest<CategoriesCubit, CategoriesStates>(
        "Test Success Case with non-empty products",
        build: () {
          when(
            mockGetProductsUseCase.call(
              params: GetProductsParams(
                category: null,
                search: null,
                sort: null,
              ),
            ),
          ).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<ProductEntity>>(responseProducts),
          );
          return categoriesCubit;
        },

        act: (cubit) => cubit.doEvent(GetProductsRequestedEvent()),

        expect: () => [
          CategoriesStates(productsState: const BaseState(isLoading: true)),
          CategoriesStates(
            productsState: BaseState(isLoading: false, data: responseProducts),
          ),
        ],

        verify: (_) => verify(
          mockGetProductsUseCase.call(
            params: GetProductsParams(category: null, search: null, sort: null),
          ),
        ).called(1),
      );
    });
    group('error', () {
      blocTest<CategoriesCubit, CategoriesStates>(
        "Test Error Case",
        build: () {
          when(
            mockGetProductsUseCase.call(
              params: GetProductsParams(
                category: null,
                search: null,
                sort: null,
              ),
            ),
          ).thenAnswer(
            (_) async => ErrorBaseResponse<List<ProductEntity>>(errorMassage),
          );
          return categoriesCubit;
        },

        act: (cubit) => cubit.doEvent(GetProductsRequestedEvent()),

        expect: () => [
          CategoriesStates(productsState: const BaseState(isLoading: true)),
          CategoriesStates(
            productsState: BaseState(
              isLoading: false,
              errorMessage: errorMassage,
            ),
          ),
        ],

        verify: (_) => verify(
          mockGetProductsUseCase.call(
            params: GetProductsParams(category: null, search: null, sort: null),
          ),
        ).called(1),
      );
    });
  });
}
