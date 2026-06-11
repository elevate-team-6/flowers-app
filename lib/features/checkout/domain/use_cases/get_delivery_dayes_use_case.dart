import 'package:flowers_app/features/checkout/domain/repos/checkout_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDeliveryDaysUseCase {
  final CheckoutRepoContract _repo;

  const GetDeliveryDaysUseCase(this._repo);

  int call() {
    return _repo.getDeliveryDays();
  }
}
