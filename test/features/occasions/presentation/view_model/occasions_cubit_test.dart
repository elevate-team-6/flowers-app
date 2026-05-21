import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/domain/use_cases/get_products_use_case.dart';
import 'package:flowers_app/features/occasions/domain/use_cases/occasions_use_case.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_cubit.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_events.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occasions_cubit_test.mocks.dart';

@GenerateMocks([OccasionsUseCase, GetProductsUseCase])
void main() {
  late MockOccasionsUseCase mockOccasionsUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late OccasionsCubit cubit;

  final fakeOccasions = [
    const OccasionEntity(
      id: '1',
      name: 'Wedding',
      slug: 'wedding',
      image: 'image.jpg',
      productsCount: 6,
    ),
  ];

  final fakeProducts = [
    const ProductEntity(
      id: '1',
      title: 'Wedding Flower',
      imgCover: 'https://image.png',
      price: 250,
      priceAfterDiscount: 100,
      discount: 60,
      description: '',
    ),
  ];

  setUp(() {
    mockOccasionsUseCase = MockOccasionsUseCase();
    mockGetProductsUseCase = MockGetProductsUseCase();
    cubit = OccasionsCubit(mockOccasionsUseCase, mockGetProductsUseCase);

    provideDummy<BaseResponse<List<OccasionEntity>>>(
      ErrorBaseResponse('dummy'),
    );
    provideDummy<BaseResponse<List<ProductEntity>>>(ErrorBaseResponse('dummy'));
  });

  tearDown(() => cubit.close());

  group('GetOccasionsEvent', () {
    blocTest<OccasionsCubit, OccasionsState>(
      'emits loading then success',
      setUp: () {
        when(
          mockOccasionsUseCase(),
        ).thenAnswer((_) async => SuccessBaseResponse(fakeOccasions));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const GetOccasionsEvent()),
      expect: () => [
        isA<OccasionsState>().having(
          (s) => s.occasionsState.isLoading,
          'isLoading',
          true,
        ),
        isA<OccasionsState>().having(
          (s) => s.occasionsState.data,
          'data',
          fakeOccasions,
        ),
      ],
    );

    blocTest<OccasionsCubit, OccasionsState>(
      'emits loading then failure',
      setUp: () {
        when(
          mockOccasionsUseCase(),
        ).thenAnswer((_) async => ErrorBaseResponse('error'));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const GetOccasionsEvent()),
      expect: () => [
        isA<OccasionsState>().having(
          (s) => s.occasionsState.isLoading,
          'isLoading',
          true,
        ),
        isA<OccasionsState>().having(
          (s) => s.occasionsState.errorMessage,
          'errorMessage',
          'error',
        ),
      ],
    );
  });

  group('GetProductsEvent', () {
    blocTest<OccasionsCubit, OccasionsState>(
      'emits loading then success',
      setUp: () {
        when(
          mockGetProductsUseCase('Wedding'),
        ).thenAnswer((_) async => SuccessBaseResponse(fakeProducts));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const GetProductsEvent('Wedding')),
      expect: () => [
        isA<OccasionsState>().having(
          (s) => s.productsState.isLoading,
          'isLoading',
          true,
        ),
        isA<OccasionsState>().having(
          (s) => s.productsState.data,
          'data',
          fakeProducts,
        ),
      ],
    );

    blocTest<OccasionsCubit, OccasionsState>(
      'emits loading then failure',
      setUp: () {
        when(
          mockGetProductsUseCase('Wedding'),
        ).thenAnswer((_) async => ErrorBaseResponse('error'));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const GetProductsEvent('Wedding')),
      expect: () => [
        isA<OccasionsState>().having(
          (s) => s.productsState.isLoading,
          'isLoading',
          true,
        ),
        isA<OccasionsState>().having(
          (s) => s.productsState.errorMessage,
          'errorMessage',
          'error',
        ),
      ],
    );
  });
}
