import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<OrderEntity> activeOrders;
  final List<OrderEntity> completedOrders;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.activeOrders = const [],
    this.completedOrders = const [],
    this.errorMessage,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderEntity>? activeOrders,
    List<OrderEntity>? completedOrders,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      activeOrders: activeOrders ?? this.activeOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    activeOrders,
    completedOrders,
    errorMessage,
  ];
}
