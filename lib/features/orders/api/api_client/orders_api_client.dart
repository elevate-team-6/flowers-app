import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/orders/data/models/order_response/orders_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'orders_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @GET(AppEndPoints.orders)
  Future<OrdersResponse> getUserOrders();
}
