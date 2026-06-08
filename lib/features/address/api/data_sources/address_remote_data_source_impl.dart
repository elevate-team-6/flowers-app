import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/address/api/api_client/address_api_client.dart';
import 'package:flowers_app/features/address/data/data_sources/address_remote_data_source_contract.dart';
import 'package:flowers_app/features/address/data/models/address_model.dart';
import 'package:flowers_app/features/address/data/models/address_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRemoteDataSourceContract)
class AddressRemoteDataSourceImpl implements AddressRemoteDataSourceContract {
  final SecureCacheHelper _cacheHelper;
  final AddressApiClient _apiClient;
  final FirebaseFirestore _firestore;

  AddressRemoteDataSourceImpl(
    this._cacheHelper,
    this._apiClient,
    this._firestore,
  );

  DocumentReference<Map<String, dynamic>> _getDefaultAddressDoc(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.defaultAddressCollection)
        .doc(AppConstants.defaultAddressDocId);
  }

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
    return ErrorHandler.handleApiCall(() async {
      final response = await _apiClient.deleteAddress(addressId);

      // If this was the default address, remove it from Firebase
      final userId = await _cacheHelper.readData(key: AppKeys.userIdKey);
      if (userId != null) {
        final doc = await _getDefaultAddressDoc(userId).get();
        if (doc.exists &&
            doc.data()?[AppConstants.firestoreIdField] == addressId) {
          await _getDefaultAddressDoc(userId).delete();
        }
      }

      return response;
    });
  }

  @override
  Future<BaseResponse<void>> setDefaultAddress(AddressModel address) {
    return ErrorHandler.handleApiCall(() async {
      final userId = await _cacheHelper.readData(key: AppKeys.userIdKey);
      if (userId == null) {
        throw Exception(AppStrings.userNotFound.tr());
      }

      await _getDefaultAddressDoc(userId).set(address.toJson());
    });
  }

  @override
  Future<BaseResponse<AddressModel?>> getDefaultAddress() {
    return ErrorHandler.handleApiCall(() async {
      final userId = await _cacheHelper.readData(key: AppKeys.userIdKey);
      if (userId == null) {
        throw Exception(AppStrings.userNotFound.tr());
      }

      final doc = await _getDefaultAddressDoc(userId).get();
      if (doc.exists && doc.data() != null) {
        return AddressModel.fromJson(doc.data()!);
      }
      return null;
    });
  }
}
