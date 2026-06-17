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
    provideDummy<BaseResponse<String>>(ErrorBaseResponse<String>('dummy'));
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

  const emptyCart = CartEntity(
    id: 'cart1',
    items: [],
    totalPrice: 0,
    totalPriceAfterDiscount: 0,
    discount: 0,
    numOfCartItems: 0,
  );

  group('GetCartEvent', () {
    blocTest<CartBloc, CartState>(
      'emits [loading, success] when getCart succeeds',
      setUp: () {
        when(
          getCartUseCase(),
        ).thenAnswer((_) async => SuccessBaseResponse(cart));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const GetCartEvent()),
      expect: () => [
        const CartState(status: CartStatus.loading),
        const CartState(status: CartStatus.success, cart: cart),
      ],
      verify: (_) => verify(getCartUseCase()).called(1),
    );

    blocTest<CartBloc, CartState>(
      'emits [loading, failure] when getCart fails',
      setUp: () {
        when(
          getCartUseCase(),
        ).thenAnswer((_) async => ErrorBaseResponse('Error'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const GetCartEvent()),
      expect: () => [
        const CartState(status: CartStatus.loading),
        const CartState(status: CartStatus.failure, errorMessage: 'Error'),
      ],
      verify: (_) => verify(getCartUseCase()).called(1),
    );

    blocTest<CartBloc, CartState>(
      'does not fetch cart when already loaded',
      setUp: () {
        when(
          getCartUseCase(),
        ).thenAnswer((_) async => SuccessBaseResponse(cart));
      },
      build: buildBloc,
      seed: () => const CartState(status: CartStatus.success, cart: cart),
      act: (bloc) => bloc.add(const GetCartEvent()),
      expect: () => <CartState>[],
      verify: (_) {
        verifyNever(getCartUseCase());
      },
    );

    group('AddToCartEvent', () {
      blocTest<CartBloc, CartState>(
        'optimistically adds item then emits success',
        setUp: () {
          when(
            addToCartUseCase('p1', 1),
          ).thenAnswer((_) async => SuccessBaseResponse(cart));
        },
        build: buildBloc,
        seed: () =>
            const CartState(status: CartStatus.success, cart: emptyCart),
        act: (bloc) => bloc.add(const AddToCartEvent(product: product)),
        expect: () => [
          // Optimistic — الـ item اتضاف فوراً
          isA<CartState>()
              .having((s) => s.cart?.items.length, 'items added', 1)
              .having((s) => s.loadingItems, 'product loading', {'p1'}),
          // Success — الـ cart الحقيقي من الـ API
          isA<CartState>()
              .having((s) => s.cart, 'final cart', cart)
              .having((s) => s.loadingItems, 'loading cleared', isEmpty),
        ],
        verify: (_) => verify(addToCartUseCase('p1', 1)).called(1),
      );

      blocTest<CartBloc, CartState>(
        'rolls back when addToCart fails',
        setUp: () {
          when(
            addToCartUseCase('p1', 1),
          ).thenAnswer((_) async => ErrorBaseResponse('Error'));
        },
        build: buildBloc,
        seed: () =>
            const CartState(status: CartStatus.success, cart: emptyCart),
        act: (bloc) => bloc.add(const AddToCartEvent(product: product)),
        expect: () => [
          // Optimistic add
          isA<CartState>()
              .having((s) => s.cart?.items.length, 'items added', 1)
              .having((s) => s.loadingItems, 'product loading', {'p1'}),
          // Rollback — الكارت يرجع فاضي + رسالة error
          isA<CartState>()
              .having((s) => s.cart, 'rollback to empty', emptyCart)
              .having((s) => s.errorMessage, 'has error', 'Error')
              .having((s) => s.loadingItems, 'loading cleared', isEmpty),
        ],
        verify: (_) => verify(addToCartUseCase('p1', 1)).called(1),
      );

      blocTest<CartBloc, CartState>(
        'does not emit when duplicate request for same product',
        setUp: () {
          when(addToCartUseCase('p1', 1)).thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 100));
            return SuccessBaseResponse(cart);
          });
        },
        build: buildBloc,
        seed: () =>
            const CartState(status: CartStatus.success, cart: emptyCart),
        act: (bloc) {
          bloc.add(const AddToCartEvent(product: product));
          bloc.add(const AddToCartEvent(product: product));
        },
        wait: const Duration(milliseconds: 200),
        verify: (_) => verify(addToCartUseCase('p1', 1)).called(1),
      );
    });
    blocTest<CartBloc, CartState>(
      'clears cart successfully',
      setUp: () {
        when(
          clearCartUseCase(),
        ).thenAnswer((_) async => SuccessBaseResponse<String>('success'));
      },
      build: buildBloc,
      seed: () => const CartState(status: CartStatus.success, cart: cart),
      act: (bloc) => bloc.add(const ClearCartEvent()),
      expect: () => [
        isA<CartState>()
            .having((s) => s.status, 'status', CartStatus.success)
            .having((s) => s.cart?.items.length, 'empty items', 0)
            .having((s) => s.cart?.numOfCartItems, 'count', 0),
      ],
    );

    group('RemoveItemEvent', () {
      blocTest<CartBloc, CartState>(
        'emits optimistic update then success',
        setUp: () {
          when(
            removeItemUseCase('p1'),
          ).thenAnswer((_) async => SuccessBaseResponse(emptyCart));
        },
        build: buildBloc,
        seed: () => const CartState(cart: cart),
        act: (bloc) =>
            bloc.add(const RemoveItemEvent(itemId: 'item1', productId: 'p1')),
        expect: () => [
          // Optimistic — الـ item اتشال من الـ UI فوراً
          isA<CartState>()
              .having((s) => s.cart?.items.length, 'items empty', 0)
              .having((s) => s.loadingItems, 'item in loading', {'item1'}),
          // Success — الـ cart النهائي من الـ API
          isA<CartState>()
              .having((s) => s.cart, 'final cart', emptyCart)
              .having((s) => s.loadingItems, 'loading cleared', isEmpty),
        ],
        verify: (_) => verify(removeItemUseCase('p1')).called(1),
      );

      blocTest<CartBloc, CartState>(
        'rolls back on failure',
        setUp: () {
          when(
            removeItemUseCase('p1'),
          ).thenAnswer((_) async => ErrorBaseResponse('Error'));
        },
        build: buildBloc,
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
        verify: (_) => verify(removeItemUseCase('p1')).called(1),
      );
    });
  });
}
