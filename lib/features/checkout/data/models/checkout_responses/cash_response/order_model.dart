import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';

class OrderModel {
  final String? id;
  final String? userId;
  final double? totalPrice;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final String? orderNumber;

  const OrderModel({
    this.id,
    this.userId,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.orderNumber,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
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
      id: id ?? '',
      orderNumber: orderNumber ?? '',
      totalPrice: totalPrice ?? 0,
      paymentType: paymentType ?? '',
      state: state ?? '',
    );
  }
}
