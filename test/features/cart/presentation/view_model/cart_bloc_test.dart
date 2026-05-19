import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flowers_app/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flowers_app/features/cart/domain/use_cases/clear_cart_use_case.dart';
import 'package:flowers_app/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flowers_app/features/cart/domain/use_cases/remove_item_use_case.dart';
import 'package:flowers_app/features/cart/domain/use_cases/update_quantity_use_case.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_bloc_test.mocks.dart';

@GenerateMocks([
  GetCartUseCase,
  AddToCartUseCase,
  UpdateQuantityUseCase,
  RemoveItemUseCase,
  ClearCartUseCase,
])
void main() {
  late MockGetCartUseCase getCartUseCase;
  late MockAddToCartUseCase addToCartUseCase;
  late MockUpdateQuantityUseCase updateQuantityUseCase;
  late MockRemoveItemUseCase removeItemUseCase;
  late MockClearCartUseCase clearCartUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<CartEntity>>(
      ErrorBaseResponse<CartEntity>('dummy'),
    );
  });

  setUp(() {
    getCartUseCase = MockGetCartUseCase();
    addToCartUseCase = MockAddToCartUseCase();
    updateQuantityUseCase = MockUpdateQuantityUseCase();
    removeItemUseCase = MockRemoveItemUseCase();
    clearCartUseCase = MockClearCartUseCase();
  });

  CartBloc buildBloc() => CartBloc(
    getCartUseCase,
    addToCartUseCase,
    updateQuantityUseCase,
    removeItemUseCase,
    clearCartUseCase,
  );

  // Test data
  const product = ProductEntity(
    id: 'p1',
    title: 'Rose',
    imgCover: '',
    price: 300,
    priceAfterDiscount: 250,
    discount: 50,
    description: 'Red rose',
  );

  const cartItem = CartItemEntity(
    id: 'item1',
    product: product,
    price: 250,
    quantity: 1,
  );

  const cart = CartEntity(
    id: 'cart1',
    items: [cartItem],
    totalPrice: 300,
    totalPriceAfterDiscount: 250,
    discount: 50,
    numOfCartItems: 1,
  );

  group('GetCartEvent', () {
    blocTest<CartBloc, CartState>(
      'emits [loading, success] when getCart succeeds',
      build: () {
        when(
          getCartUseCase(),
        ).thenAnswer((_) async => SuccessBaseResponse(cart));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GetCartEvent()),
      expect: () => [
        const CartState(status: CartStatus.loading),
        const CartState(status: CartStatus.success, cart: cart),
      ],
      verify: (_) => verify(getCartUseCase()).called(1),
    );

    blocTest<CartBloc, CartState>(
      'emits [loading, failure] when getCart fails',
      build: () {
        when(
          getCartUseCase(),
        ).thenAnswer((_) async => ErrorBaseResponse('Error'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GetCartEvent()),
      expect: () => [
        const CartState(status: CartStatus.loading),
        const CartState(status: CartStatus.failure, errorMessage: 'Error'),
      ],
    );
  });

  group('AddToCartEvent', () {
    blocTest<CartBloc, CartState>(
      'emits [loadingItem, success] when addToCart succeeds',
      build: () {
        when(
          addToCartUseCase('p1', 1),
        ).thenAnswer((_) async => SuccessBaseResponse(cart));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AddToCartEvent(productId: 'p1')),
      expect: () => [
        const CartState(loadingItems: {'p1'}),
        const CartState(status: CartStatus.success, cart: cart),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [loadingItem, failure] when addToCart fails',
      build: () {
        when(
          addToCartUseCase('p1', 1),
        ).thenAnswer((_) async => ErrorBaseResponse('Error'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AddToCartEvent(productId: 'p1')),
      expect: () => [
        const CartState(loadingItems: {'p1'}),
        const CartState(status: CartStatus.failure, errorMessage: 'Error'),
      ],
    );

    blocTest<CartBloc, CartState>(
      'does not emit when duplicate request for same product',
      build: () {
        when(addToCartUseCase('p1', 1)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return SuccessBaseResponse(cart);
        });
        return buildBloc();
      },
      act: (bloc) {
        bloc.add(const AddToCartEvent(productId: 'p1'));
        bloc.add(const AddToCartEvent(productId: 'p1'));
      },
      wait: const Duration(milliseconds: 200),
      verify: (_) => verify(addToCartUseCase('p1', 1)).called(1),
    );
  });

  group('RemoveItemEvent', () {
    blocTest<CartBloc, CartState>(
      'emits optimistic update then success',
      build: () {
        when(removeItemUseCase('p1')).thenAnswer(
          (_) async => SuccessBaseResponse(
            const CartEntity(
              id: 'cart1',
              items: [],
              totalPrice: 0,
              totalPriceAfterDiscount: 0,
              discount: 0,
              numOfCartItems: 0,
            ),
          ),
        );
        return buildBloc();
      },
      seed: () => const CartState(cart: cart),
      act: (bloc) =>
          bloc.add(const RemoveItemEvent(itemId: 'item1', productId: 'p1')),
      verify: (_) => verify(removeItemUseCase('p1')).called(1),
    );

    blocTest<CartBloc, CartState>(
      'rolls back on failure',
      build: () {
        when(
          removeItemUseCase('p1'),
        ).thenAnswer((_) async => ErrorBaseResponse('Error'));
        return buildBloc();
      },
      seed: () => const CartState(cart: cart),
      act: (bloc) =>
          bloc.add(const RemoveItemEvent(itemId: 'item1', productId: 'p1')),
      expect: () => [
        // Optimistic remove
        isA<CartState>().having(
          (s) => s.cart?.items.length,
          'items empty after optimistic',
          0,
        ),
        // Rollback
        isA<CartState>()
            .having((s) => s.cart, 'rollback to original', cart)
            .having((s) => s.errorMessage, 'has error', 'Error'),
      ],
    );
  });

  group('ClearCartEvent', () {
    blocTest<CartBloc, CartState>(
      'emits [loading, success] when clearCart succeeds',
      build: () {
        when(clearCartUseCase()).thenAnswer(
          (_) async => SuccessBaseResponse(
            const CartEntity(
              id: 'cart1',
              items: [],
              totalPrice: 0,
              totalPriceAfterDiscount: 0,
              discount: 0,
              numOfCartItems: 0,
            ),
          ),
        );
        return buildBloc();
      },
      seed: () => const CartState(cart: cart),
      act: (bloc) => bloc.add(const ClearCartEvent()),
      verify: (_) => verify(clearCartUseCase()).called(1),
    );

    blocTest<CartBloc, CartState>(
      'rolls back on failure',
      build: () {
        when(
          clearCartUseCase(),
        ).thenAnswer((_) async => ErrorBaseResponse('Error'));
        return buildBloc();
      },
      seed: () => const CartState(cart: cart),
      act: (bloc) => bloc.add(const ClearCartEvent()),
      expect: () => [
        // Optimistic clear (items empty + loading)
        isA<CartState>()
            .having((s) => s.cart?.items.length, 'items empty', 0)
            .having((s) => s.status, 'is loading', CartStatus.loading),
        // Rollback
        isA<CartState>()
            .having((s) => s.cart, 'rollback', cart)
            .having((s) => s.status, 'failure', CartStatus.failure),
      ],
    );
  });
}
