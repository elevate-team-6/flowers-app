import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address_details/domain/repos/address_details_repo_contrect.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDefaultAddressUseCase {
  final AddressDetailsRepoContrect _repository;

  GetDefaultAddressUseCase(this._repository);

  Future<BaseResponse<AddressEntity?>> call() {
    return _repository.getDefaultAddress();
  }
}
