import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/orders/domain/entities/order_item_entity.dart';

class OrderItemDto extends Equatable {
  final String? id;
  final ProductEntity? product;
  final int? price;
  final int? quantity;

  const OrderItemDto({this.id, this.product, this.price, this.quantity});

  factory OrderItemDto.fromJson(Map<String, dynamic> json) => OrderItemDto(
    id: json['_id'] as String?,
    product: json['product'] != null
        ? ProductEntity.fromJson(json['product'] as Map<String, dynamic>)
        : null,
    price: (json['price'] as num?)?.toInt(),
    quantity: (json['quantity'] as num?)?.toInt(),
  );

  OrderItemEntity toEntity() => OrderItemEntity(
    id: id ?? '',
    product: product ?? ProductEntity.empty,
    price: price ?? 0,
    quantity: quantity ?? 1,
  );

  @override
  List<Object?> get props => [id, product, price, quantity];
}
