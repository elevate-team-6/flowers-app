import 'dart:io';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/edit_profile/data/data_sources/edit_profile_remote_data_source_contract.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/edit_profile_response.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/entities/user_edit_profile_entity.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/repos/edit_profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EditProfileRepoContract)
class EditProfileRepoImpl implements EditProfileRepoContract {
  final EditProfileRemoteDataSourceContract _editProfileRemoteDataSource;
  const EditProfileRepoImpl(this._editProfileRemoteDataSource);
  @override
  Future<BaseResponse<UserEditProfileEntity>> editProfile(
    EditProfileRequest request,
  ) async {
    final response = await _editProfileRemoteDataSource.editProfile(request);

    switch (response) {
      case SuccessBaseResponse<EditProfileResponse>():
        return SuccessBaseResponse<UserEditProfileEntity>(
          response.data.user.toEntity(),
        );

      case ErrorBaseResponse<EditProfileResponse>():
        return ErrorBaseResponse<UserEditProfileEntity>(response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<String>> uploadPhoto(File file) async {
    final response = await _editProfileRemoteDataSource.uploadPhoto(file);
    switch (response) {
      case SuccessBaseResponse<String>():
        return SuccessBaseResponse<String>(response.data);
      case ErrorBaseResponse<String>():
        return ErrorBaseResponse<String>(response.errorMessage);
    }
  }
}
