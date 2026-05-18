import 'dart:async';
import 'package:flowers_app/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flowers_app/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flowers_app/features/cart/domain/use_cases/update_quantity_use_case.dart';
import 'package:flowers_app/features/cart/domain/use_cases/remove_item_use_case.dart';
import 'package:flowers_app/features/cart/domain/use_cases/clear_cart_use_case.dart';
import 'cart_event.dart';
import 'cart_state.dart';

@lazySingleton
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateQuantityUseCase _updateQuantityUseCase;
  final RemoveItemUseCase _removeItemUseCase;
  final ClearCartUseCase _clearCartUseCase;

  // Debounce timers per item
  final Map<String, Timer> _debounceTimers = {};
  // Pending quantities per item
  final Map<String, int> _pendingQuantities = {};
  // Active requests per item
  final Set<String> _activeRequests = {};

  CartBloc(
    this._getCartUseCase,
    this._addToCartUseCase,
    this._updateQuantityUseCase,
    this._removeItemUseCase,
    this._clearCartUseCase,
  ) : super(const CartState()) {
    on<GetCartEvent>(_onGetCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<RemoveItemEvent>(_onRemoveItem);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onGetCart(GetCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _getCartUseCase();
    switch (result) {
      case SuccessBaseResponse<CartEntity>():
        emit(state.copyWith(status: CartStatus.success, cart: result.data));
      case ErrorBaseResponse<CartEntity>():
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: result.errorMessage,
          ),
        );
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    if (_activeRequests.contains(event.productId)) return;
    _activeRequests.add(event.productId);

    emit(
      state.copyWith(loadingItems: {...state.loadingItems, event.productId}),
    );

    final result = await _addToCartUseCase(event.productId, event.quantity);
    _activeRequests.remove(event.productId);

    final newLoadingItems = Set<String>.from(state.loadingItems)
      ..remove(event.productId);

    switch (result) {
      case SuccessBaseResponse<CartEntity>():
        emit(
          state.copyWith(
            status: CartStatus.success,
            cart: result.data,
            loadingItems: newLoadingItems,
          ),
        );
      case ErrorBaseResponse<CartEntity>():
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: result.errorMessage,
            loadingItems: newLoadingItems,
          ),
        );
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    if (event.quantity <= 0) {
      add(RemoveItemEvent(itemId: event.itemId, productId: event.productId));
      return;
    }

    // Optimistic Update
    final oldCart = state.cart;
    final updatedItems = state.cart?.items.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    if (updatedItems != null && oldCart != null) {
      emit(
        state.copyWith(
          cart: oldCart.copyWith(items: updatedItems),
          loadingItems: {...state.loadingItems, event.itemId},
        ),
      );
    }

    // Debounce
    _pendingQuantities[event.itemId] = event.quantity;
    _debounceTimers[event.itemId]?.cancel();

    // ← استخدم Completer عشان الـ emit يبقى داخل الـ handler
    final completer = Completer<void>();
    _debounceTimers[event.itemId] = Timer(
      const Duration(milliseconds: 600),
      () => completer.complete(),
    );
    await completer.future;

    final quantity = _pendingQuantities[event.itemId];
    if (quantity == null) return;

    final result = await _updateQuantityUseCase(event.productId, quantity);

    final newLoadingItems = Set<String>.from(state.loadingItems)
      ..remove(event.itemId);

    switch (result) {
      case SuccessBaseResponse<CartEntity>():
        emit(state.copyWith(cart: result.data, loadingItems: newLoadingItems));
      case ErrorBaseResponse<CartEntity>():
        emit(
          state.copyWith(
            cart: oldCart,
            loadingItems: newLoadingItems,
            errorMessage: result.errorMessage,
          ),
        );
    }
    _pendingQuantities.remove(event.itemId);
  }

  Future<void> _onRemoveItem(
    RemoveItemEvent event,
    Emitter<CartState> emit,
  ) async {
    // Optimistic Update
    final oldCart = state.cart;
    final updatedItems = state.cart?.items
        .where((item) => item.id != event.itemId)
        .toList();

    if (updatedItems != null && oldCart != null) {
      emit(
        state.copyWith(
          cart: oldCart.copyWith(items: updatedItems),
          loadingItems: {...state.loadingItems, event.itemId},
        ),
      );
    }

    final result = await _removeItemUseCase(event.productId);

    final newLoadingItems = Set<String>.from(state.loadingItems)
      ..remove(event.itemId);

    switch (result) {
      case SuccessBaseResponse<CartEntity>():
        emit(state.copyWith(cart: result.data, loadingItems: newLoadingItems));
      case ErrorBaseResponse<CartEntity>():
        // Rollback
        emit(
          state.copyWith(
            cart: oldCart,
            loadingItems: newLoadingItems,
            errorMessage: result.errorMessage,
          ),
        );
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final oldCart = state.cart;
    // Optimistic Update
    emit(
      state.copyWith(
        cart: oldCart?.copyWith(items: []),
        status: CartStatus.loading,
      ),
    );

    final result = await _clearCartUseCase();

    switch (result) {
      case SuccessBaseResponse<CartEntity>():
        emit(state.copyWith(status: CartStatus.success, cart: result.data));
      case ErrorBaseResponse<CartEntity>():
        // Rollback
        emit(
          state.copyWith(
            status: CartStatus.failure,
            cart: oldCart,
            errorMessage: result.errorMessage,
          ),
        );
    }
  }

  @override
  Future<void> close() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}
