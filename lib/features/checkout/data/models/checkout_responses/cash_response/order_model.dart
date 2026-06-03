import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';

class OrderModel {
  final String id;
  final String userId;
  final double totalPrice;
  final String paymentType;
  final bool isPaid;
  final bool isDelivered;
  final String state;
  final String orderNumber;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
    required this.isDelivered,
    required this.state,
    required this.orderNumber,
  });

  factory OrderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderModel(
      id: json['_id'] ?? '',
      userId: json['user'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      paymentType: json['paymentType'] ?? '',
      isPaid: json['isPaid'] ?? false,
      isDelivered: json['isDelivered'] ?? false,
      state: json['state'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
    );
  }

  OrderEntity toDomain() {
    return OrderEntity(
      id: id,
      orderNumber: orderNumber,
      totalPrice: totalPrice,
      paymentType: paymentType,
      state: state,
    );
  }
}