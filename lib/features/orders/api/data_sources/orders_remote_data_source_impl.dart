import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/orders/api/api_client/orders_api_client.dart';
import 'package:flowers_app/features/orders/data/data_sources/orders_remote_data_source_contract.dart';
import 'package:flowers_app/features/orders/data/models/response/orders_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRemoteDataSourceContract)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSourceContract {
  final OrdersApiClient _apiClient;

  const OrdersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<OrdersResponse>> getUserOrders() =>
      ErrorHandler.handleApiCall(() => _apiClient.getUserOrders());
}
