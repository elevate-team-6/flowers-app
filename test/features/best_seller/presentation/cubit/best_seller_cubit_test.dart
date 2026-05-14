import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/best_seller/domain/use_cases/best_seller_use_case.dart';
import 'package:flowers_app/features/best_seller/presentation/cubit/best_seller_cubit.dart';
import 'package:flowers_app/features/best_seller/presentation/cubit/best_seller_event.dart';
import 'package:flowers_app/features/best_seller/presentation/cubit/best_seller_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'best_seller_cubit_test.mocks.dart';

@GenerateMocks([BestSellerUseCase])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessBaseResponse<List<ProductEntity>>([]),
    );
  });

  late MockBestSellerUseCase mockBestSellerUseCase;

  late BestSellerCubit bestSellerCubit;

  setUp(() {
    mockBestSellerUseCase = MockBestSellerUseCase();

    bestSellerCubit = BestSellerCubit(mockBestSellerUseCase);
  });

  group('Best Seller Cubit Tests', () {
    final products = [
      ProductEntity(
        id: '1',
        title: 'Rose',

        imgCover: '',
        price: 100,
        priceAfterDiscount: 80,
        discount: 20,
      ),
    ];

    blocTest<BestSellerCubit, BestSellerState>(
      'should emit loading then success state',
      build: () {
        when(mockBestSellerUseCase.call()).thenAnswer(
          (_) async => SuccessBaseResponse<List<ProductEntity>>(products),
        );

        return bestSellerCubit;
      },
      act: (cubit) async {
        await cubit.doEvent(GetBestSellerProductsEvent());
      },
      expect: () => [
        BestSellerState(
          bestSellerState: BaseState(isLoading: true, errorMessage: null),
        ),
        BestSellerState(
          bestSellerState: BaseState(
            isLoading: false,
            data: products,
            errorMessage: null,
          ),
        ),
      ],
      verify: (_) {
        verify(mockBestSellerUseCase.call()).called(1);
      },
    );

    blocTest<BestSellerCubit, BestSellerState>(
      'should emit loading then error state',
      build: () {
        when(mockBestSellerUseCase.call()).thenAnswer(
          (_) async => ErrorBaseResponse<List<ProductEntity>>('Error'),
        );

        return bestSellerCubit;
      },
      act: (cubit) async {
        await cubit.doEvent(GetBestSellerProductsEvent());
      },
      expect: () => [
        BestSellerState(
          bestSellerState: BaseState(isLoading: true, errorMessage: null),
        ),
        BestSellerState(
          bestSellerState: BaseState(isLoading: false, errorMessage: 'Error'),
        ),
      ],
      verify: (_) {
        verify(mockBestSellerUseCase.call()).called(1);
      },
    );
  });
}
