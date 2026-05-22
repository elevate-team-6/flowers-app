import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  final String id;
  final ProductEntity product;
  final int price;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.product,
    required this.price,
    required this.quantity,
  });

  CartItemEntity copyWith({int? quantity}) => CartItemEntity(
    id: id,
    product: product,
    price: price,
    quantity: quantity ?? this.quantity,
  );

  int get total => price * quantity;

  @override
  List<Object?> get props => [id, product, price, quantity];
}
