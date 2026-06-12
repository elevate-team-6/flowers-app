import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:flowers_app/features/orders/domain/entities/order_item_entity.dart';
import 'order_item_dto.dart';

class OrderDto extends Equatable {
  final String? id;
  final String? user;
  final String? orderNumber;
  final List<OrderItemDto>? orderItems;
  final int? totalPrice;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final String? createdAt;
  final String? updatedAt;

  const OrderDto({
    this.id,
    this.user,
    this.orderNumber,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) => OrderDto(
    id: json['_id'] as String?,
    user: json['user'] as String?,
    orderNumber: json['orderNumber'] as String?,
    orderItems: (json['orderItems'] as List<dynamic>?)
        ?.map((e) => OrderItemDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    totalPrice: (json['totalPrice'] as num?)?.toInt(),
    paymentType: json['paymentType'] as String?,
    isPaid: json['isPaid'] as bool?,
    isDelivered: json['isDelivered'] as bool?,
    state: json['state'] as String?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
  );

  OrderEntity toEntity() => OrderEntity(
    id: id ?? '',
    userId: user ?? '',
    orderNumber: orderNumber ?? '',
    items: orderItems?.map((e) => e.toEntity()).toList() ?? <OrderItemEntity>[],
    totalPrice: totalPrice ?? 0,
    paymentType: paymentType ?? '',
    isPaid: isPaid ?? false,
    isDelivered: isDelivered ?? false,
    state: _mapState(state),
    createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(updatedAt ?? '') ?? DateTime.now(),
  );

  static OrderStatus _mapState(String? state) {
    switch (state) {
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }

  @override
  List<Object?> get props => [
    id,
    user,
    orderNumber,
    orderItems,
    totalPrice,
    paymentType,
    isPaid,
    isDelivered,
    state,
    createdAt,
    updatedAt,
  ];
}
