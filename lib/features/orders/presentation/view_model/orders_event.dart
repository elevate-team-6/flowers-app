import 'package:equatable/equatable.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class GetUserOrdersEvent extends OrdersEvent {
  const GetUserOrdersEvent();
}
