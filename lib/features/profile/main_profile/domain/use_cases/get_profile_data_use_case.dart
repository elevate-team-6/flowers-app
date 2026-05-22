import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../entities/user_profile_entity.dart';
import '../repos/profile_repo_contract.dart';

@injectable
class GetProfileDataUseCase {
  final ProfileRepoContract _repo;

  GetProfileDataUseCase(this._repo);

  Future<BaseResponse<UserProfileEntity>> call() async {
    return await _repo.getProfileData();
  }
}
