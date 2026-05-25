import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/entities/user_edit_profile_entity.dart';
import 'package:flowers_app/features/profile/edit_profile/domain/repos/edit_profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditProfileUseCase {
  final EditProfileRepoContract _editProfileRepo;
  const EditProfileUseCase(this._editProfileRepo);
  Future<BaseResponse<UserEditProfileEntity>> call(EditProfileRequest request) {
    return _editProfileRepo.editProfile(request);
  }
}
