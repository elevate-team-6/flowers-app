import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/data/models/city_model.dart';
import 'package:flowers_app/features/address/data/models/governorate_model.dart';

abstract interface class AddressLocalDataSourceContract {
  Future<BaseResponse<List<GovernorateModel>>> getGovernorates();
  Future<BaseResponse<List<CityModel>>> getCities(String governorateId);
}
