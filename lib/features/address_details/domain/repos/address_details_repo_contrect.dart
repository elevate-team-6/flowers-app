import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address_details/domain/entities/address_entity.dart';

abstract interface class AddressDetailsRepoContrect {
  Future<BaseResponse<List<AddressEntity>>> getAddresses();

  Future<BaseResponse<void>> setDefaultAddress(
    AddressEntity address, {
    bool selectedByUser = true,
  });
  Future<BaseResponse<AddressEntity?>> getDefaultAddress();
}
