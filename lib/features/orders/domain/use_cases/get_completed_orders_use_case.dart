import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCompletedOrdersUseCase {
  const GetCompletedOrdersUseCase();

  List<OrderEntity> call(List<OrderEntity> orders) {
    return orders.where((order) => !order.isActive).toList();
  }
}
