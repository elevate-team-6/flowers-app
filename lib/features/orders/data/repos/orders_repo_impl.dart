import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/orders/data/data_sources/orders_remote_data_source_contract.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:flowers_app/features/orders/domain/repos/orders_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRepoContract)
class OrdersRepoImpl implements OrdersRepoContract {
  final OrdersRemoteDataSourceContract _dataSource;

  const OrdersRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<List<OrderEntity>>> getUserOrders() =>
      _dataSource.getUserOrders();
}
