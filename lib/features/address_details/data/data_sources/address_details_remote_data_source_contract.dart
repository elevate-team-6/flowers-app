import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';

abstract interface class AddressDetailsRemoteDataSourceContract {
  Future<BaseResponse<void>> setDefaultAddress(
    String userId,
    AddressModel address, {
    bool selectedByUser = true,
  });
  Future<BaseResponse<AddressModel?>> getDefaultAddress(String userId);
}
