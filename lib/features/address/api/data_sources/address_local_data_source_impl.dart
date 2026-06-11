import 'dart:convert';

import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/address/data/data_sources/address_local_data_source_contract.dart';
import 'package:flowers_app/features/address/data/models/city_model.dart';
import 'package:flowers_app/features/address/data/models/governorate_model.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressLocalDataSourceContract)
class AddressLocalDataSourceImpl implements AddressLocalDataSourceContract {
  @override
  Future<BaseResponse<List<GovernorateModel>>> getGovernorates() async {
    try {
      final String response = await rootBundle.loadString(
        AppConstants.governoratesJsonPath,
      );
      final List<dynamic> data = json.decode(response);

      final governoratesData =
          data.firstWhere(
                (element) =>
                    element[AppConstants.jsonNameKey] ==
                    AppConstants.governoratesKey,
              )[AppConstants.jsonDataKey]
              as List;

      final governorates = governoratesData
          .map((e) => GovernorateModel.fromJson(e))
          .toList();
      return SuccessBaseResponse(governorates);
    } catch (e) {
      return ErrorBaseResponse(e.toString());
    }
  }

  @override
  Future<BaseResponse<List<CityModel>>> getCities(String governorateId) async {
    try {
      final String response = await rootBundle.loadString(
        AppConstants.citiesJsonPath,
      );
      final List<dynamic> data = json.decode(response);

      final citiesData =
          data.firstWhere(
                (element) =>
                    element[AppConstants.jsonNameKey] == AppConstants.citiesKey,
              )[AppConstants.jsonDataKey]
              as List;

      final cities = citiesData
          .map((e) => CityModel.fromJson(e))
          .where((city) => city.governorateId == governorateId)
          .toList();

      return SuccessBaseResponse(cities);
    } catch (e) {
      return ErrorBaseResponse(e.toString());
    }
  }
}
