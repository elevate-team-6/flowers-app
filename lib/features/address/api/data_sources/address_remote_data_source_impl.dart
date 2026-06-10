import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
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
  Future<BaseResponse<AddressResponse>> getAddresses() async {
    try {
      final response = await _apiClient.getAddresses();
      return SuccessBaseResponse(response);
    } catch (e) {
      return ErrorBaseResponse(e.toString());
    }
  }

  @override
  Future<BaseResponse<AddressResponse>> addAddress(AddressModel address) async {
    try {
      final response = await _apiClient.addAddress(address);
      return SuccessBaseResponse(response);
    } catch (e) {
      return ErrorBaseResponse(e.toString());
    }
  }

  @override
  Future<BaseResponse<AddressResponse>> updateAddress(
    AddressModel address,
  ) async {
    try {
      if (address.id == null) {
        return ErrorBaseResponse(AppStrings.addressIdRequired.tr());
      }
      final response = await _apiClient.updateAddress(address.id!, address);
      return SuccessBaseResponse(response);
    } catch (e) {
      return ErrorBaseResponse(e.toString());
    }
  }

  @override
  Future<BaseResponse<AddressResponse>> deleteAddress(String addressId) async {
    try {
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

      return SuccessBaseResponse(response);
    } catch (e) {
      return ErrorBaseResponse(e.toString());
    }
  }

  @override
  Future<BaseResponse<void>> setDefaultAddress(
    AddressModel address, {
    bool selectedByUser = true,
  }) async {
    try {
      final userId = await _cacheHelper.readData(key: AppKeys.userIdKey);

      if (userId == null) {
        return ErrorBaseResponse(AppStrings.userNotFound.tr());
      }

      await _getDefaultAddressDoc(userId).set({
        ...address.toJson(),
        '_id': address.id,
        'selectedByUser': selectedByUser,
      });
      return SuccessBaseResponse(null);
    } catch (e) {
      return ErrorBaseResponse(e.toString());
    }
  }

  @override
  Future<BaseResponse<AddressModel?>> getDefaultAddress() async {
    try {
      final userId = await _cacheHelper.readData(key: AppKeys.userIdKey);

      if (userId == null) {
        return ErrorBaseResponse(AppStrings.userNotFound.tr());
      }

      final doc = await _getDefaultAddressDoc(userId).get();

      if (doc.exists && doc.data() != null) {
        return SuccessBaseResponse(AddressModel.fromJson(doc.data()!));
      }
      return SuccessBaseResponse(null);
    } catch (e) {
      return ErrorBaseResponse(e.toString());
    }
  }
}
