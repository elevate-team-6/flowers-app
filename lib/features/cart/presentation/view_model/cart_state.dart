import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity? cart;
  final String? errorMessage;
  final Set<String> loadingItems;
  final bool itemAddedSuccess;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
    this.loadingItems = const {},
    this.itemAddedSuccess = false,
  });

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    String? errorMessage,
    Set<String>? loadingItems,
    bool? itemAddedSuccess,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
      loadingItems: loadingItems ?? this.loadingItems,
      itemAddedSuccess: itemAddedSuccess ?? false,
    );
  }

  bool isItemLoading(String itemId) => loadingItems.contains(itemId);

  @override
  List<Object?> get props => [status, cart, errorMessage, loadingItems];
}
