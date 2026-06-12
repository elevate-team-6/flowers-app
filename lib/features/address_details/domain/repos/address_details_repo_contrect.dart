import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';

abstract interface class AddressDetailsRepoContrect {
  Future<BaseResponse<void>> setDefaultAddress(
    AddressEntity address, {
    bool selectedByUser = true,
  });

  Future<BaseResponse<AddressEntity?>> getDefaultAddress();
}
