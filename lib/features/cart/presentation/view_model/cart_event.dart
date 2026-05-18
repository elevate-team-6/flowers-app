import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class GetCartEvent extends CartEvent {
  const GetCartEvent();
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  const AddToCartEvent({required this.productId, this.quantity = 1});

  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateQuantityEvent extends CartEvent {
  final String itemId;
  final String productId;
  final int quantity;

  const UpdateQuantityEvent({
    required this.itemId,
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [itemId, productId, quantity];
}

class RemoveItemEvent extends CartEvent {
  final String itemId;
  final String productId;

  const RemoveItemEvent({required this.itemId, required this.productId});

  @override
  List<Object?> get props => [itemId, productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();

  @override
  List<Object?> get props => [];
}
