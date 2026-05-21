import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/best_seller/domain/use_cases/best_seller_use_case.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';
import 'package:flowers_app/features/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flowers_app/features/home/presentation/view_model/cubit/home_view_model.dart';
import 'package:flowers_app/features/home/presentation/view_model/events/home_events.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/domain/use_cases/occasions_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../best_seller/presentation/cubit/best_seller_cubit_test.mocks.dart';
import '../../../../categories/presentation/view_model/categories_cubit_test.mocks.dart';
import '../../../../occasions/presentation/view_model/occasions_cubit_test.mocks.dart';

@GenerateMocks([OccasionsUseCase, GetCategoriesUseCase, BestSellerUseCase])
void main() {
  late HomeViewModel homeViewModel;
  late MockOccasionsUseCase mockOccasionsUseCase;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockBestSellerUseCase mockBestSellerUseCase;

  late List<OccasionEntity> occasionsList;
  late List<ProductEntity> productsList;
  late List<CategoryEntity> categoriesList;
  late String errMsg;

  setUpAll(() {
    errMsg = "Something went wrong. Please try again later.";

    occasionsList = [
      const OccasionEntity(
        id: '1',
        name: 'Birthday',
        slug: 'birthday',
        image: 'image_url',
        productsCount: 10,
      ),
    ];

    productsList = [
      const ProductEntity(
        id: '1',
        title: 'Rose Bouquet',
        imgCover: 'image_url',
        price: 100,
        priceAfterDiscount: 80,
        discount: 20,
      ),
    ];

    categoriesList = const [CategoryEntity(id: '1', name: 'Flowers')];

    provideDummy<BaseResponse<List<OccasionEntity>>>(
      SuccessBaseResponse<List<OccasionEntity>>([]),
    );
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessBaseResponse<List<ProductEntity>>([]),
    );
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessBaseResponse<List<CategoryEntity>>([]),
    );

    mockOccasionsUseCase = MockOccasionsUseCase();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockBestSellerUseCase = MockBestSellerUseCase();
  });

  setUp(() {
    homeViewModel = HomeViewModel(
      mockOccasionsUseCase,
      mockGetCategoriesUseCase,
      mockBestSellerUseCase,
    );
  });

  group('Home View Model Test Group', () {
    group('GetAllHomeData — Occasions', () {
      blocTest<HomeViewModel, HomeStates>(
        'emits [loading, success] for occasions when succeeds',
        build: () {
          when(mockOccasionsUseCase.call()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<OccasionEntity>>(occasionsList),
          );
          when(mockBestSellerUseCase.call()).thenAnswer(
            (_) async => SuccessBaseResponse<List<ProductEntity>>(productsList),
          );
          when(mockGetCategoriesUseCase.call()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<CategoryEntity>>(categoriesList),
          );
          return homeViewModel;
        },
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        expect: () => [
          HomeStates(
            occasionsState: BaseState<List<OccasionEntity>>(isLoading: true),
          ),
          HomeStates(
            occasionsState: BaseState<List<OccasionEntity>>(
              isLoading: false,
              data: occasionsList,
            ),
          ),
        ],
        verify: (_) {
          verify(mockOccasionsUseCase.call()).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        'emits [loading, error] for occasions when fails',
        build: () {
          when(mockOccasionsUseCase.call()).thenAnswer(
            (_) async => ErrorBaseResponse<List<OccasionEntity>>(errMsg),
          );
          when(mockBestSellerUseCase.call()).thenAnswer(
            (_) async => SuccessBaseResponse<List<ProductEntity>>(productsList),
          );
          when(mockGetCategoriesUseCase.call()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<CategoryEntity>>(categoriesList),
          );
          return homeViewModel;
        },
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        expect: () => [
          HomeStates(
            occasionsState: BaseState<List<OccasionEntity>>(isLoading: true),
          ),
          HomeStates(
            occasionsState: BaseState<List<OccasionEntity>>(
              errorMessage: errMsg,
            ),
          ),
        ],
        verify: (_) {
          verify(mockOccasionsUseCase.call()).called(1);
        },
      );
    });

    group('GetAllHomeData — Best Seller', () {
      blocTest<HomeViewModel, HomeStates>(
        'emits [loading, success] for bestSeller when succeeds',
        build: () {
          when(mockOccasionsUseCase.call()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<OccasionEntity>>(occasionsList),
          );
          when(mockBestSellerUseCase.call()).thenAnswer(
            (_) async => SuccessBaseResponse<List<ProductEntity>>(productsList),
          );
          when(mockGetCategoriesUseCase.call()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<CategoryEntity>>(categoriesList),
          );
          return homeViewModel;
        },
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        expect: () => [
          HomeStates(
            bestSellerState: BaseState<List<ProductEntity>>(isLoading: true),
          ),
          HomeStates(
            bestSellerState: BaseState<List<ProductEntity>>(
              isLoading: false,
              data: productsList,
            ),
          ),
        ],
        verify: (_) {
          verify(mockBestSellerUseCase.call()).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        'emits [loading, error] for bestSeller when fails',
        build: () {
          when(mockOccasionsUseCase.call()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<OccasionEntity>>(occasionsList),
          );
          when(mockBestSellerUseCase.call()).thenAnswer(
            (_) async => ErrorBaseResponse<List<ProductEntity>>(errMsg),
          );
          when(mockGetCategoriesUseCase.call()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<CategoryEntity>>(categoriesList),
          );
          return homeViewModel;
        },
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        expect: () => [
          HomeStates(
            bestSellerState: BaseState<List<ProductEntity>>(isLoading: true),
          ),
          HomeStates(
            bestSellerState: BaseState<List<ProductEntity>>(
              errorMessage: errMsg,
            ),
          ),
        ],
        verify: (_) {
          verify(mockBestSellerUseCase.call()).called(1);
        },
      );
    });

    group('GetAllHomeData — Categories', () {
      blocTest<HomeViewModel, HomeStates>(
        'emits [loading, success] for categories when succeeds',
        build: () {
          when(mockOccasionsUseCase.call()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<OccasionEntity>>(occasionsList),
          );
          when(mockBestSellerUseCase.call()).thenAnswer(
            (_) async => SuccessBaseResponse<List<ProductEntity>>(productsList),
          );
          when(mockGetCategoriesUseCase.call()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<CategoryEntity>>(categoriesList),
          );
          return homeViewModel;
        },
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        expect: () => [
          HomeStates(
            categoryState: BaseState<List<CategoryEntity>>(isLoading: true),
          ),
          HomeStates(
            categoryState: BaseState<List<CategoryEntity>>(
              isLoading: false,
              data: categoriesList,
            ),
          ),
        ],
        verify: (_) {
          verify(mockGetCategoriesUseCase.call()).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        'emits [loading, error] for categories when fails',
        build: () {
          when(mockOccasionsUseCase.call()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<List<OccasionEntity>>(occasionsList),
          );
          when(mockBestSellerUseCase.call()).thenAnswer(
            (_) async => SuccessBaseResponse<List<ProductEntity>>(productsList),
          );
          when(mockGetCategoriesUseCase.call()).thenAnswer(
            (_) async => ErrorBaseResponse<List<CategoryEntity>>(errMsg),
          );
          return homeViewModel;
        },
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        expect: () => [
          HomeStates(
            categoryState: BaseState<List<CategoryEntity>>(isLoading: true),
          ),
          HomeStates(
            categoryState: BaseState<List<CategoryEntity>>(
              errorMessage: errMsg,
            ),
          ),
        ],
        verify: (_) {
          verify(mockGetCategoriesUseCase.call()).called(1);
        },
      );
    });
  });
}
