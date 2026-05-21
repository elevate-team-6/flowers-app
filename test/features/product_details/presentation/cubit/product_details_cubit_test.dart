import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flowers_app/features/product_details/domain/use_cases/product_details_use_case.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_event.dart';
import 'package:flowers_app/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_details_cubit_test.mocks.dart';

@GenerateMocks([ProductDetailsUseCase])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<ProductDetailsEntity>>(
      SuccessBaseResponse(
        ProductDetailsEntity(
          title: '',
          description: '',
          images: [],
          price: 0,
          quantity: 0,
          imgCover: '',
        ),
      ),
    );
  });
  late MockProductDetailsUseCase mockProductDetailsUseCase;
  late ProductDetailsCubit cubit;

  setUp(() {
    mockProductDetailsUseCase = MockProductDetailsUseCase();
    cubit = ProductDetailsCubit(mockProductDetailsUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('ProductDetailsCubit', () {
    const productId = '1';

    final product = ProductDetailsEntity(
      title: 'Rose',
      description: 'Beautiful flower',
      images: ['image'],
      price: 200,
      quantity: 5,
      imgCover: '',
    );

    blocTest<ProductDetailsCubit, ProductDetailsState>(
      'emit loading then success state when usecase returns success',
      build: () {
        when(mockProductDetailsUseCase.call(productId)).thenAnswer(
          (_) async => SuccessBaseResponse<ProductDetailsEntity>(product),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(GetProductDetailsEvent(productId));
      },
      expect: () => [
        const ProductDetailsState().copyWith(
          productDetailsState: const BaseState<ProductDetailsEntity>(
            isLoading: true,
          ),
        ),
        ProductDetailsState().copyWith(
          productDetailsState: BaseState<ProductDetailsEntity>(
            isLoading: false,
            data: product,
          ),
        ),
      ],
      verify: (_) {
        verify(mockProductDetailsUseCase.call(productId)).called(1);
      },
    );

    blocTest<ProductDetailsCubit, ProductDetailsState>(
      'emit loading then error state when usecase returns error',
      build: () {
        when(mockProductDetailsUseCase.call(productId)).thenAnswer(
          (_) async =>
              ErrorBaseResponse<ProductDetailsEntity>('error occurred'),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(GetProductDetailsEvent(productId));
      },
      expect: () => [
        const ProductDetailsState().copyWith(
          productDetailsState: const BaseState<ProductDetailsEntity>(
            isLoading: true,
          ),
        ),
        const ProductDetailsState().copyWith(
          productDetailsState: BaseState<ProductDetailsEntity>(
            isLoading: false,
            errorMessage: 'error occurred',
          ),
        ),
      ],
      verify: (_) {
        verify(mockProductDetailsUseCase.call(productId)).called(1);
      },
    );
  });
}
