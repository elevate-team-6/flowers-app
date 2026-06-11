import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';

abstract interface class AddressRepoContract {
  Future<BaseResponse<List<AddressEntity>>> getAddresses();
  Future<BaseResponse<List<AddressEntity>>> addAddress(AddressEntity address);
  Future<BaseResponse<List<AddressEntity>>> updateAddress(
    AddressEntity address,
  );
  Future<BaseResponse<List<AddressEntity>>> deleteAddress(String addressId);
  Future<BaseResponse<List<GovernorateEntity>>> getGovernorates();
  Future<BaseResponse<List<CityEntity>>> getCities(String governorateId);
}
