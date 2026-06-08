import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/orders/data/models/response/orders_response.dart';

abstract interface class OrdersRemoteDataSourceContract {
  Future<BaseResponse<OrdersResponse>> getUserOrders();
}
