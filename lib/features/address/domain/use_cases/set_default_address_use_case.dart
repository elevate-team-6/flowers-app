import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/repositories/address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetDefaultAddressUseCase {
  final AddressRepoContract _repository;

  SetDefaultAddressUseCase(this._repository);

  Future<BaseResponse<void>> call(AddressEntity address) {
    return _repository.setDefaultAddress(address);
  }
}
