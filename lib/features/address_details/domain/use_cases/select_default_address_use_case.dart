import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address_details/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/set_default_address_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class SelectDefaultAddressUseCase {
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;

  SelectDefaultAddressUseCase(this._setDefaultAddressUseCase);

  Future<BaseResponse<void>> call(AddressEntity address) {
    return _setDefaultAddressUseCase(address, selectedByUser: true);
  }
}