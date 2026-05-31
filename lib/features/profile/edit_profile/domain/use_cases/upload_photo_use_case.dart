import 'dart:io';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/repos/edit_profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadProfileUseCase {
  final EditProfileRepoContract _editProfileRepo;
  const UploadProfileUseCase(this._editProfileRepo);
  Future<BaseResponse<String>> call(File file) {
    return _editProfileRepo.uploadPhoto(file);
  }
}
