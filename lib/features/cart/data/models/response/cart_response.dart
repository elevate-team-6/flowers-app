import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';
import 'cart_item_model.dart';

class CartResponse extends Equatable {
  final String? message;
  final int? numOfCartItems;
  final CartDataModel? cart;

  const CartResponse({this.message, this.numOfCartItems, this.cart});

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
    message: json['message'] as String?,
    numOfCartItems: json['numOfCartItems'] as int?,
    cart: json['cart'] != null
        ? CartDataModel.fromJson(json['cart'] as Map<String, dynamic>)
        : null,
  );

  CartEntity toEntity() => CartEntity(
    id: cart?.id ?? '',
    items: cart?.cartItems?.map((e) => e.toEntity()).toList() ?? [],
    totalPrice: cart?.totalPrice ?? 0,
    totalPriceAfterDiscount: cart?.totalPriceAfterDiscount ?? 0,
    discount: cart?.discount ?? 0,
    numOfCartItems: numOfCartItems ?? 0,
  );

  @override
  List<Object?> get props => [message, numOfCartItems, cart];
}

class CartDataModel extends Equatable {
  final String? id;
  final String? user;
  final List<CartItemModel>? cartItems;
  final int? discount;
  final int? totalPrice;
  final int? totalPriceAfterDiscount;

  const CartDataModel({
    this.id,
    this.user,
    this.cartItems,
    this.discount,
    this.totalPrice,
    this.totalPriceAfterDiscount,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) => CartDataModel(
    id: json['_id'] as String?,
    user: json['user'] as String?,
    cartItems: (json['cartItems'] as List<dynamic>?)
        ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    discount: (json['discount'] as num?)?.toInt(),
    totalPrice: (json['totalPrice'] as num?)?.toInt(),
    totalPriceAfterDiscount: (json['totalPriceAfterDiscount'] as num?)?.toInt(),
  );

  @override
  List<Object?> get props => [
    id,
    user,
    cartItems,
    discount,
    totalPrice,
    totalPriceAfterDiscount,
  ];
}
