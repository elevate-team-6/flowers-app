import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';
import 'package:flowers_app/features/address/data/models/address_response.dart';

abstract interface class AddressRemoteDataSourceContract {
  Future<BaseResponse<AddressResponse>> getAddresses();
  Future<BaseResponse<AddressResponse>> addAddress(AddressModel address);
  Future<BaseResponse<AddressResponse>> updateAddress(AddressModel address);
  Future<BaseResponse<AddressResponse>> deleteAddress(String addressId);
}
