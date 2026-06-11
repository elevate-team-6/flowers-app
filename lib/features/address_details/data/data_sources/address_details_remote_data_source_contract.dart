import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address_details/data/models/address_model.dart';
import 'package:flowers_app/features/address_details/data/models/address_response.dart';

abstract interface class AddressDetailsRemoteDataSourceContract {
  Future<BaseResponse<AddressResponse>> getAddresses();

  Future<BaseResponse<void>> setDefaultAddress(
    AddressModel address, {
    bool selectedByUser = true,
  });
  Future<BaseResponse<AddressModel?>> getDefaultAddress();
}
