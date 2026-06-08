import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<OrderEntity> orders;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.errorMessage,
  });

  // helper getters للـ UI
  List<OrderEntity> get activeOrders =>
      orders.where((order) => order.isActive).toList();

  List<OrderEntity> get completedOrders =>
      orders.where((order) => !order.isActive).toList();

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderEntity>? orders,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMessage];
}
