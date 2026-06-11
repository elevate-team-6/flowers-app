import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/address/api/api_client/address_api_client.dart';
import 'package:flowers_app/features/address/data/data_sources/address_remote_data_source_contract.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';
import 'package:flowers_app/features/address/data/models/address_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRemoteDataSourceContract)
class AddressRemoteDataSourceImpl implements AddressRemoteDataSourceContract {
  final AddressApiClient _apiClient;

  AddressRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<AddressResponse>> getAddresses() {
    return ErrorHandler.handleApiCall(() => _apiClient.getAddresses());
  }

  @override
  Future<BaseResponse<AddressResponse>> addAddress(AddressModel address) {
    return ErrorHandler.handleApiCall(() => _apiClient.addAddress(address));
  }

  @override
  Future<BaseResponse<AddressResponse>> updateAddress(
    AddressModel address,
  ) async {
    if (address.id == null) {
      return ErrorBaseResponse(AppStrings.addressIdRequired.tr());
    }
    return ErrorHandler.handleApiCall(
      () => _apiClient.updateAddress(address.id!, address),
    );
  }

  @override
  Future<BaseResponse<AddressResponse>> deleteAddress(String addressId) {
    return ErrorHandler.handleApiCall(
      () => _apiClient.deleteAddress(addressId),
    );
  }
}
