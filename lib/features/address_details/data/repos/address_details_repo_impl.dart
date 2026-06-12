import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/address_details/data/data_sources/address_details_remote_data_source_contract.dart';
import 'package:flowers_app/features/address_details/data/models/address_model.dart';
import 'package:flowers_app/features/address_details/data/models/address_response.dart';
import 'package:flowers_app/features/address_details/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address_details/domain/repos/address_details_repo_contrect.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressDetailsRepoContrect)
class AddressRepoDetailsImpl implements AddressDetailsRepoContrect {
  final AddressDetailsRemoteDataSourceContract _remoteDataSource;
  final SecureCacheHelper _cacheHelper;

  const AddressRepoDetailsImpl(this._remoteDataSource, this._cacheHelper);

  @override
  Future<BaseResponse<List<AddressEntity>>> getAddresses() async {
    final response = await _remoteDataSource.getAddresses();

    if (response is SuccessBaseResponse<AddressResponse>) {
      return SuccessBaseResponse([]);
    }

    return ErrorBaseResponse((response as ErrorBaseResponse).errorMessage);
  }

  @override
  Future<BaseResponse<AddressEntity?>> getDefaultAddress() async {
    final userId = await _cacheHelper.readData(key: AppKeys.userIdKey);

    if (userId == null) {
      return ErrorBaseResponse(AppStrings.userNotFound.tr());
    }

    final result = await _remoteDataSource.getDefaultAddress(userId);

    if (result is SuccessBaseResponse<AddressModel?>) {
      final model = result.data;

      if (model == null) {
        return SuccessBaseResponse(null);
      }

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
  Future<BaseResponse<void>> setDefaultAddress(
    AddressEntity address, {
    bool selectedByUser = true,
  }) async {
    final userId = await _cacheHelper.readData(key: AppKeys.userIdKey);

    if (userId == null) {
      return ErrorBaseResponse(AppStrings.userNotFound.tr());
    }

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

    return _remoteDataSource.setDefaultAddress(
      userId,
      model,
      selectedByUser: selectedByUser,
    );
  }
}
