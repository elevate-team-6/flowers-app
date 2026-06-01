import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/profile/edit_profile/api/api_client/edit_profile_api_client.dart';
import 'package:flowers_app/features/profile/edit_profile/data/data_sources/edit_profile_remote_data_source_contract.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_response/edit_profile_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EditProfileRemoteDataSourceContract)
class EditProfileRemoteDataSourctImpl
    implements EditProfileRemoteDataSourceContract {
  final EditProfileApiClient _editProfileApiClient;

  const EditProfileRemoteDataSourctImpl(this._editProfileApiClient);

  @override
  Future<BaseResponse<EditProfileResponse>> editProfile(
    EditProfileRequest request,
  ) {
    return ErrorHandler.handleApiCall(
      () async => _editProfileApiClient.editProfile(request),
    );
  }

  @override
  Future<BaseResponse<String>> uploadPhoto(File file) {
    return ErrorHandler.handleApiCall(() async {
      final image = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      );

      final response = await _editProfileApiClient.uploadPhoto(image);

      return response.message;
    });
  }
}
