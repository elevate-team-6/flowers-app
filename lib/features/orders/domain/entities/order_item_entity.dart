import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/entities/product_entity.dart';

class OrderItemEntity extends Equatable {
  final String id;
  final ProductEntity product;
  final int price;
  final int quantity;

  const OrderItemEntity({
    required this.id,
    required this.product,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, product, price, quantity];
}
