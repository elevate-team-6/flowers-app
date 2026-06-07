import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:flowers_app/features/orders/domain/repos/orders_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserOrdersUseCase {
  final OrdersRepoContract _repo;

  const GetUserOrdersUseCase(this._repo);

  Future<BaseResponse<List<OrderEntity>>> call() => _repo.getUserOrders();
}
