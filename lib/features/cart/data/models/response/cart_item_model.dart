import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_item_entity.dart';

class CartItemModel extends Equatable {
  final String? id;
  final ProductEntity? product;
  final int? price;
  final int? quantity;

  const CartItemModel({this.id, this.product, this.price, this.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    id: json['_id'] as String?,
    product: json['product'] != null
        ? ProductEntity.fromJson(json['product'] as Map<String, dynamic>)
        : null,
    price: (json['price'] as num?)?.toInt(),
    quantity: (json['quantity'] as num?)?.toInt(),
  );

  CartItemEntity toEntity() => CartItemEntity(
    id: id ?? '',
    product: product!,
    price: price ?? 0,
    quantity: quantity ?? 1,
  );

  @override
  List<Object?> get props => [id, product, price, quantity];
}
