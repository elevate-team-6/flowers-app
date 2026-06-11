import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String orderNumber;
  final double totalPrice;
  final String paymentType;
  final String state;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.totalPrice,
    required this.paymentType,
    required this.state,
  });

  @override
  List<Object?> get props => [id, orderNumber, totalPrice, paymentType, state];
}
