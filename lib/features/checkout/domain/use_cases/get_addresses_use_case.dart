import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/checkout/domain/entities/address_entity.dart';
import 'package:flowers_app/features/checkout/domain/repos/checkout_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetAddressesUseCase {
  final CheckoutRepoContract _checkoutRepo;
  const GetAddressesUseCase(this._checkoutRepo);
  Future<BaseResponse<List<AddressEntity>>> call() {
    return _checkoutRepo.addresses();
  }
}
