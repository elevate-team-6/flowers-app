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

  Future<List<AddressEntity>> _mapAndSync(AddressResponse response) async {
    final models = response.addresses ?? [];

    // Get default address from Firebase
    final defaultResult = await _remoteDataSource.getDefaultAddress();
    String? defaultId;
    if (defaultResult is SuccessBaseResponse<AddressModel?>) {
      defaultId = defaultResult.data?.id;
    }

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
        isDefault: model.id != null && model.id == defaultId,
      );
    }).toList();
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> getAddresses() async {
    final response = await _remoteDataSource.getAddresses();
    if (response is SuccessBaseResponse<AddressResponse>) {
      final syncedList = await _mapAndSync(response.data);
      return SuccessBaseResponse(syncedList);
    }
    return ErrorBaseResponse((response as ErrorBaseResponse).errorMessage);
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> addAddress(
    AddressEntity address,
  ) async {
    final model = AddressModel(
      id: address.id,
      username: address.recipientName,
      phone: address.phoneNumber,
      // Store Area and Street combined
      street:
          "${address.area}${AppConstants.addressDelimiter}${address.street}",
      city: address.city,
      lat: address.latitude,
      long: address.longitude,
    );
    final response = await _remoteDataSource.addAddress(model);
    if (response is SuccessBaseResponse<AddressResponse>) {
      final syncedList = await _mapAndSync(response.data);
      return SuccessBaseResponse(syncedList);
    }
    return ErrorBaseResponse((response as ErrorBaseResponse).errorMessage);
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
    if (response is SuccessBaseResponse<AddressResponse>) {
      final syncedList = await _mapAndSync(response.data);
      return SuccessBaseResponse(syncedList);
    }
    return ErrorBaseResponse((response as ErrorBaseResponse).errorMessage);
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> deleteAddress(
    String addressId,
  ) async {
    final response = await _remoteDataSource.deleteAddress(addressId);
    if (response is SuccessBaseResponse<AddressResponse>) {
      final syncedList = await _mapAndSync(response.data);
      return SuccessBaseResponse(syncedList);
    }
    return ErrorBaseResponse((response as ErrorBaseResponse).errorMessage);
  }

  @override
  Future<BaseResponse<void>> setDefaultAddress(AddressEntity address) {
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
    return _remoteDataSource.setDefaultAddress(model);
  }

  @override
  Future<BaseResponse<AddressEntity?>> getDefaultAddress() async {
    final result = await _remoteDataSource.getDefaultAddress();
    if (result is SuccessBaseResponse<AddressModel?>) {
      final model = result.data;
      if (model == null) return SuccessBaseResponse(null);

      String area = "";
      String street = model.street ?? "";
      if (street.contains(AppConstants.addressDelimiter)) {
        final parts = street.split(AppConstants.addressDelimiter);
        area = parts[0];
        street = parts.sublist(1).join(AppConstants.addressDelimiter);
      }

      return SuccessBaseResponse(
        AddressEntity(
          id: model.id,
          recipientName: model.username ?? '',
          phoneNumber: model.phone ?? '',
          street: street,
          area: area,
          city: model.city ?? '',
          latitude: model.lat ?? '',
          longitude: model.long ?? '',
          isDefault: true,
        ),
      );
    }
    return ErrorBaseResponse((result as ErrorBaseResponse).errorMessage);
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
