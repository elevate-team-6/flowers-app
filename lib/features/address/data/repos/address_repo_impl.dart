import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/address/data/data_sources/address_local_data_source_contract.dart';
import 'package:flowers_app/features/address/data/data_sources/address_remote_data_source_contract.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';
import 'package:flowers_app/features/address/data/models/address_response.dart';
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

  List<AddressEntity> _mapToEntityList(AddressResponse response) {
    final models = response.addresses ?? [];

    return models.map((model) {
      String area = "";
      String street = model.street ?? "";

      // Try to split area and street if delimiter exists
      if (street.contains(AppConstants.addressDelimiter)) {
        final parts = street.split(AppConstants.addressDelimiter);
        area = parts[0];
        street = parts.sublist(1).join(AppConstants.addressDelimiter);
      }

      return AddressEntity(
        id: model.id,
        recipientName: model.username ?? '',
        phoneNumber: model.phone ?? '',
        street: street,
        area: area,
        city: model.city ?? '',
        latitude: model.lat ?? '',
        longitude: model.long ?? '',
        isDefault: false, // Default logic removed as requested
      );
    }).toList();
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> getAddresses() async {
    final response = await _remoteDataSource.getAddresses();
    return switch (response) {
      SuccessBaseResponse<AddressResponse>() => SuccessBaseResponse(
        _mapToEntityList(response.data),
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
    final model = AddressModel(
      id: address.id,
      username: address.recipientName,
      phone: address.phoneNumber,
      street:
          "${address.area}${AppConstants.addressDelimiter}${address.street}",
      city: address.city,
      lat: address.latitude,
      long: address.longitude,
    );
    final response = await _remoteDataSource.addAddress(model);
    return switch (response) {
      SuccessBaseResponse<AddressResponse>() => SuccessBaseResponse(
        _mapToEntityList(response.data),
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
    final model = AddressModel(
      id: address.id,
      username: address.recipientName,
      phone: address.phoneNumber,
      street:
          "${address.area}${AppConstants.addressDelimiter}${address.street}",
      city: address.city,
      lat: address.latitude,
      long: address.longitude,
    );
    final response = await _remoteDataSource.updateAddress(model);
    return switch (response) {
      SuccessBaseResponse<AddressResponse>() => SuccessBaseResponse(
        _mapToEntityList(response.data),
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
        _mapToEntityList(response.data),
      ),
      ErrorBaseResponse<AddressResponse>() => ErrorBaseResponse(
        response.errorMessage,
      ),
    };
  }

  @override
  Future<BaseResponse<List<GovernorateEntity>>> getGovernorates() {
    return _localDataSource.getGovernorates();
  }

  @override
  Future<BaseResponse<List<CityEntity>>> getCities(String governorateId) {
    return _localDataSource.getCities(governorateId);
  }
}
