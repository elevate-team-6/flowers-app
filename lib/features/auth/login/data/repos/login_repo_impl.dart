import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/auth/login/data/data_sources/login_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/login_response.dart';
import 'package:flowers_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:flowers_app/features/auth/login/domain/repositories/login_repo_contract.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginRepoContract)
class LoginRepoImpl implements LoginRepoContract {
  final LoginRemoteDataSourceContract _loginRemoteDataSource;
  final FirebaseFirestore _firestore;

  const LoginRepoImpl(this._loginRemoteDataSource, this._firestore);
  @override
  Future<BaseResponse<UserEntity>> login(LoginRequest request) async {
    final response = await _loginRemoteDataSource.login(request);
    switch (response) {
      case SuccessBaseResponse<LoginResponse>():
        final data = response.data;
        if (data.user == null) {
          return ErrorBaseResponse(AppStrings.someThingWentWrong.tr());
        }
        final user = data.user!;

        // --- تحديث بيانات اليوزر والـ FCM Token في Firestore ---
        try {
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(user.id)
              .set({
                AppConstants.firestoreIdField: user.id,
                AppConstants.fcmTokenField: fcmToken,
              }, SetOptions(merge: true));
        } catch (e) {
          debugPrint("Error updating Firestore user: $e");
        }

        return SuccessBaseResponse(
          UserEntity(
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            gender: user.gender,
            phone: user.phone,
            photo: user.photo,
            role: user.role,
            createdAt: user.createdAt,
            token: data.token,
          ),
        );
      case ErrorBaseResponse<LoginResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }
}
