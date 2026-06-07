import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

enum OrderStatus { pending, delivered, cancelled }

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String orderNumber;
  final List<OrderItemEntity> items;
  final int totalPrice;
  final String paymentType;
  final bool isPaid;
  final bool isDelivered;
  final OrderStatus state;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.items,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
    required this.isDelivered,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => !isDelivered;

  @override
  List<Object?> get props => [
    id,
    userId,
    orderNumber,
    items,
    totalPrice,
    paymentType,
    isPaid,
    isDelivered,
    state,
    createdAt,
    updatedAt,
  ];
}
