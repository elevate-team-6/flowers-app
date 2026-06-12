import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';

abstract interface class OrdersRepoContract {
  Future<BaseResponse<List<OrderEntity>>> getUserOrders();
}
