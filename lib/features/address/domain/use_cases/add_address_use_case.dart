import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/repositories/address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddAddressUseCase {
  final AddressRepoContract _repository;

  AddAddressUseCase(this._repository);

  Future<BaseResponse<List<AddressEntity>>> call(AddressEntity address) {
    return _repository.addAddress(address);
  }
}
