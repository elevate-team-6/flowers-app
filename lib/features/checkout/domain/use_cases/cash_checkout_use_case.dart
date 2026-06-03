import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';
import 'package:flowers_app/features/checkout/domain/repos/checkout_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class CashCheckoutUseCase {
  final CheckoutRepoContract _checkoutRepo;
  const CashCheckoutUseCase(this._checkoutRepo);
  Future<BaseResponse<OrderEntity>> call(CheckoutRequest request) {
    return _checkoutRepo.cashCheckout(request);
  }
}
