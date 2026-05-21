import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
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

import 'home_view_model_test.mocks.dart';

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

    occasionsList = const [
      OccasionEntity(
        id: '1',
        name: 'Birthday',
        slug: 'birthday',
        image: 'image_url',
        productsCount: 10,
      ),
    ];

    productsList = const [
      ProductEntity(
        id: '1',
        title: 'Rose Bouquet',
        imgCover: 'image_url',
        price: 100,
        priceAfterDiscount: 80,
        discount: 20,
        description: '',
      ),
    ];

    categoriesList = const [CategoryEntity(id: '1', name: 'Flowers')];

    provideDummy<BaseResponse<List<OccasionEntity>>>(
      SuccessBaseResponse<List<OccasionEntity>>(const []),
    );
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessBaseResponse<List<ProductEntity>>(const []),
    );
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessBaseResponse<List<CategoryEntity>>(const []),
    );
  });

  setUp(() {
    mockOccasionsUseCase = MockOccasionsUseCase();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockBestSellerUseCase = MockBestSellerUseCase();
    homeViewModel = HomeViewModel(
      mockOccasionsUseCase,
      mockGetCategoriesUseCase,
      mockBestSellerUseCase,
    );
  });

  // helper — stub لكل الـ use cases بنجاح
  void stubAllSuccess() {
    when(mockOccasionsUseCase.call()).thenAnswer(
      (_) async => SuccessBaseResponse<List<OccasionEntity>>(occasionsList),
    );
    when(mockBestSellerUseCase.call()).thenAnswer(
      (_) async => SuccessBaseResponse<List<ProductEntity>>(productsList),
    );
    when(mockGetCategoriesUseCase.call()).thenAnswer(
      (_) async => SuccessBaseResponse<List<CategoryEntity>>(categoriesList),
    );
  }

  group('Home View Model Test Group', () {
    // GetAllHomeData بيشغّل 3 use cases — بيـ emit 6 states
    // (3 loading + 3 result). نتخطّى أول 5 ونفحص الأخير.

    group('GetAllHomeData — Occasions', () {
      blocTest<HomeViewModel, HomeStates>(
        'final state has occasions data when succeeds',
        setUp: stubAllSuccess,
        build: () => homeViewModel,
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        skip: 5,
        expect: () => [
          isA<HomeStates>().having(
            (s) => s.occasionsState.data,
            'occasions data',
            occasionsList,
          ),
        ],
        verify: (_) {
          verify(mockOccasionsUseCase.call()).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        'final state has occasions error when fails',
        setUp: () {
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
        },
        build: () => homeViewModel,
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        skip: 5,
        expect: () => [
          isA<HomeStates>().having(
            (s) => s.occasionsState.errorMessage,
            'occasions error',
            errMsg,
          ),
        ],
        verify: (_) {
          verify(mockOccasionsUseCase.call()).called(1);
        },
      );
    });

    group('GetAllHomeData — Best Seller', () {
      blocTest<HomeViewModel, HomeStates>(
        'final state has bestSeller data when succeeds',
        setUp: stubAllSuccess,
        build: () => homeViewModel,
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        skip: 5,
        expect: () => [
          isA<HomeStates>().having(
            (s) => s.bestSellerState.data,
            'bestSeller data',
            productsList,
          ),
        ],
        verify: (_) {
          verify(mockBestSellerUseCase.call()).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        'final state has bestSeller error when fails',
        setUp: () {
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
        },
        build: () => homeViewModel,
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        skip: 5,
        expect: () => [
          isA<HomeStates>().having(
            (s) => s.bestSellerState.errorMessage,
            'bestSeller error',
            errMsg,
          ),
        ],
        verify: (_) {
          verify(mockBestSellerUseCase.call()).called(1);
        },
      );
    });

    group('GetAllHomeData — Categories', () {
      blocTest<HomeViewModel, HomeStates>(
        'final state has categories data when succeeds',
        setUp: stubAllSuccess,
        build: () => homeViewModel,
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        skip: 5,
        expect: () => [
          isA<HomeStates>().having(
            (s) => s.categoryState.data,
            'categories data',
            categoriesList,
          ),
        ],
        verify: (_) {
          verify(mockGetCategoriesUseCase.call()).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        'final state has categories error when fails',
        setUp: () {
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
        },
        build: () => homeViewModel,
        act: (cubit) => cubit.doEvent(GetAllHomeData()),
        skip: 5,
        expect: () => [
          isA<HomeStates>().having(
            (s) => s.categoryState.errorMessage,
            'categories error',
            errMsg,
          ),
        ],
        verify: (_) {
          verify(mockGetCategoriesUseCase.call()).called(1);
        },
      );
    });
  });
}
