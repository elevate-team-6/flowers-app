import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/address_details/api/address_details_api_client.dart';
import 'package:flowers_app/features/address_details/data/data_sources/address_details_remote_data_source_contract.dart';
import 'package:flowers_app/features/address_details/data/models/address_model.dart';
import 'package:flowers_app/features/address_details/data/models/address_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressDetailsRemoteDataSourceContract)
class AddressDetailsRemoteDataSourceImpl
    implements AddressDetailsRemoteDataSourceContract {
  final SecureCacheHelper _cacheHelper;
  final FirebaseFirestore _firestore;
  final AddressDetailsApiClient _apiClient;

  const AddressDetailsRemoteDataSourceImpl(
    this._cacheHelper,
    this._firestore,
    this._apiClient,
  );
  DocumentReference<Map<String, dynamic>> _getDefaultAddressDoc(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.defaultAddressCollection)
        .doc(AppConstants.defaultAddressDocId);
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
  Future<BaseResponse<void>> setDefaultAddress(
    AddressModel address, {
    bool selectedByUser = true,
  }) async {
    return ErrorHandler.handleApiCall(() async {
      final userId = await _cacheHelper.readData(key: AppKeys.userIdKey);
      if (userId == null) {
        throw Exception(AppStrings.userNotFound.tr());
      }

      await _getDefaultAddressDoc(userId).set({
        ...address.toJson(),
        '_id': address.id,
        'selectedByUser': selectedByUser,
      });
    });
  }
}
