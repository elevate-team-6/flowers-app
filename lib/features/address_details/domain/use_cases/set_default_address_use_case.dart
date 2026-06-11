import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address_details/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address_details/domain/repos/address_details_repo_contrect.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetDefaultAddressUseCase {
  final AddressDetailsRepoContrect _repository;

  SetDefaultAddressUseCase(this._repository);

  Future<BaseResponse<void>> call(
    AddressEntity address, {
    bool selectedByUser = true,
  }) {
    return _repository.setDefaultAddress(address);
  }
}