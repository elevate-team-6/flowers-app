import 'dart:io';

import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/edit_profile_response.dart';

abstract interface class EditProfileRemoteDataSourceContract {
  Future<BaseResponse<EditProfileResponse>> editProfile(
    EditProfileRequest request,
  );
  Future<BaseResponse<String>> uploadPhoto(File file);
}
