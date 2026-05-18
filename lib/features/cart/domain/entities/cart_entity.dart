import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final int totalPrice;
  final int totalPriceAfterDiscount;
  final int discount;
  final int numOfCartItems;

  const CartEntity({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.totalPriceAfterDiscount,
    required this.discount,
    required this.numOfCartItems,
  });

  CartEntity copyWith({
    List<CartItemEntity>? items,
    int? totalPrice,
    int? totalPriceAfterDiscount,
    int? discount,
    int? numOfCartItems,
  }) => CartEntity(
    id: id,
    items: items ?? this.items,
    totalPrice: totalPrice ?? this.totalPrice,
    totalPriceAfterDiscount:
        totalPriceAfterDiscount ?? this.totalPriceAfterDiscount,
    discount: discount ?? this.discount,
    numOfCartItems: numOfCartItems ?? this.numOfCartItems,
  );

  @override
  List<Object?> get props => [
    id,
    items,
    totalPrice,
    totalPriceAfterDiscount,
    discount,
    numOfCartItems,
  ];
}
