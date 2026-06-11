import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address_details/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address_details/domain/repos/address_details_repo_contrect.dart';

class GetAddressesUseCase {
    final AddressDetailsRepoContrect _repository;

  GetAddressesUseCase(this._repository);

  Future<BaseResponse<List<AddressEntity>>> call() {
    return _repository.getAddresses();
  }
}