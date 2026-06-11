import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/data/data_sources/address_local_data_source_contract.dart';
import 'package:flowers_app/features/address/data/data_sources/address_remote_data_source_contract.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';
import 'package:flowers_app/features/address/data/models/address_response.dart';
import 'package:flowers_app/features/address/data/models/city_model.dart';
import 'package:flowers_app/features/address/data/models/governorate_model.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flowers_app/features/address/domain/repositories/address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRepoContract)
class AddressRepoImpl implements AddressRepoContract {
  final AddressRemoteDataSourceContract _remoteDataSource;
  final AddressLocalDataSourceContract _localDataSource;

  AddressRepoImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<BaseResponse<List<AddressEntity>>> getAddresses() async {
    final response = await _remoteDataSource.getAddresses();
    return switch (response) {
      SuccessBaseResponse<AddressResponse>() => SuccessBaseResponse(
        response.data.toEntity(),
      ),
      ErrorBaseResponse<AddressResponse>() => ErrorBaseResponse(
        response.errorMessage,
      ),
    };
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> addAddress(
    AddressEntity address,
  ) async {
    final response = await _remoteDataSource.addAddress(
      AddressModel.fromEntity(address),
    );
    return switch (response) {
      SuccessBaseResponse<AddressResponse>() => SuccessBaseResponse(
        response.data.toEntity(),
      ),
      ErrorBaseResponse<AddressResponse>() => ErrorBaseResponse(
        response.errorMessage,
      ),
    };
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> updateAddress(
    AddressEntity address,
  ) async {
    final response = await _remoteDataSource.updateAddress(
      AddressModel.fromEntity(address),
    );
    return switch (response) {
      SuccessBaseResponse<AddressResponse>() => SuccessBaseResponse(
        response.data.toEntity(),
      ),
      ErrorBaseResponse<AddressResponse>() => ErrorBaseResponse(
        response.errorMessage,
      ),
    };
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> deleteAddress(
    String addressId,
  ) async {
    final response = await _remoteDataSource.deleteAddress(addressId);
    return switch (response) {
      SuccessBaseResponse<AddressResponse>() => SuccessBaseResponse(
        response.data.toEntity(),
      ),
      ErrorBaseResponse<AddressResponse>() => ErrorBaseResponse(
        response.errorMessage,
      ),
    };
  }

  @override
  Future<BaseResponse<List<GovernorateEntity>>> getGovernorates() async {
    final response = await _localDataSource.getGovernorates();
    return switch (response) {
      SuccessBaseResponse<List<GovernorateModel>>() => SuccessBaseResponse(
        response.data.map((model) => model.toEntity()).toList(),
      ),
      ErrorBaseResponse<List<GovernorateModel>>() => ErrorBaseResponse(
        response.errorMessage,
      ),
    };
  }

  @override
  Future<BaseResponse<List<CityEntity>>> getCities(String governorateId) async {
    final response = await _localDataSource.getCities(governorateId);
    return switch (response) {
      SuccessBaseResponse<List<CityModel>>() => SuccessBaseResponse(
        response.data.map((model) => model.toEntity()).toList(),
      ),
      ErrorBaseResponse<List<CityModel>>() => ErrorBaseResponse(
        response.errorMessage,
      ),
    };
  }
}
