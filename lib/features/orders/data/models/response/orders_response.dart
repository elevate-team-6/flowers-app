import 'package:equatable/equatable.dart';
import 'order_dto.dart';

class OrdersResponse extends Equatable {
  final String? message;
  final List<OrderDto>? orders;

  const OrdersResponse({this.message, this.orders});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => OrdersResponse(
    message: json['message'] as String?,
    orders: (json['orders'] as List<dynamic>?)
        ?.map((e) => OrderDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  @override
  List<Object?> get props => [message, orders];
}
