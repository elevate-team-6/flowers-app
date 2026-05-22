import 'package:flowers_app/features/profile/main_profile/domain/repos/profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';

@injectable
class LogoutUseCase {
  final ProfileRepoContract _repo;
  LogoutUseCase(this._repo);

  Future<BaseResponse<void>> logout() async {
    return await _repo.logout();
  }
}
