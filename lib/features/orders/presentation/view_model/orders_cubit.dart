import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:flowers_app/features/orders/domain/use_cases/get_active_orders_use_case.dart';
import 'package:flowers_app/features/orders/domain/use_cases/get_completed_orders_use_case.dart';
import 'package:flowers_app/features/orders/domain/use_cases/get_user_orders_use_case.dart';
import 'package:flowers_app/features/orders/presentation/view_model/orders_event.dart';
import 'package:flowers_app/features/orders/presentation/view_model/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  final GetUserOrdersUseCase _getUserOrdersUseCase;
  final GetActiveOrdersUseCase _getActiveOrdersUseCase;
  final GetCompletedOrdersUseCase _getCompletedOrdersUseCase;

  OrdersCubit(
    this._getUserOrdersUseCase,
    this._getActiveOrdersUseCase,
    this._getCompletedOrdersUseCase,
  ) : super(const OrdersState());

  Future<void> doEvent(OrdersEvent event) async {
    switch (event) {
      case GetUserOrdersEvent():
        await _getUserOrders();
    }
  }

  Future<void> _getUserOrders() async {
    emit(state.copyWith(status: OrdersStatus.loading, errorMessage: null));

    final result = await _getUserOrdersUseCase();

    switch (result) {
      case SuccessBaseResponse<List<OrderEntity>>():
        // استخدم الـ use cases لتقسيم الـ orders
        final allOrders = result.data ?? [];
        final activeOrders = _getActiveOrdersUseCase(allOrders);
        final completedOrders = _getCompletedOrdersUseCase(allOrders);

        emit(
          state.copyWith(
            status: OrdersStatus.success,
            activeOrders: activeOrders,
            completedOrders: completedOrders,
          ),
        );

      case ErrorBaseResponse<List<OrderEntity>>():
        emit(
          state.copyWith(
            status: OrdersStatus.failure,
            errorMessage: result.errorMessage,
          ),
        );
    }
  }
}
