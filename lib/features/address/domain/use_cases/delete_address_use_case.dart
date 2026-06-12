import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/repositories/address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAddressUseCase {
  final AddressRepoContract _repository;

  DeleteAddressUseCase(this._repository);

  Future<BaseResponse<List<AddressEntity>>> call(String addressId) {
    return _repository.deleteAddress(addressId);
  }
}
