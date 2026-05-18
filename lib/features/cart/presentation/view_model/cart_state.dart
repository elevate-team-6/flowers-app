import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity? cart;
  final String? errorMessage;
  final Set<String> loadingItems; // item ids اللي بتتحدث دلوقتي

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
    this.loadingItems = const {},
  });

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    String? errorMessage,
    Set<String>? loadingItems,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
      loadingItems: loadingItems ?? this.loadingItems,
    );
  }

  bool isItemLoading(String itemId) => loadingItems.contains(itemId);

  @override
  List<Object?> get props => [status, cart, errorMessage, loadingItems];
}
