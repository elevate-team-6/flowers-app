import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';
import 'package:flowers_app/features/checkout/domain/repos/checkout_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class CardCheckoutUseCase {
  final CheckoutRepoContract _checkoutRepo;
  const CardCheckoutUseCase(this._checkoutRepo);
  Future<BaseResponse<CardEntity>> call(
    String cartId,
    CheckoutRequest request,
  ) {
    return _checkoutRepo.cardCheckout(cartId, request);
  }
}
