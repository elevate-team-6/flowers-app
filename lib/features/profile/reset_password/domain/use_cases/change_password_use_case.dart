import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/reset_password/domain/repos/change_password_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ChangePasswordRepoContract _repo;
  const ChangePasswordUseCase(this._repo);

  Future<BaseResponse<String>> call(String password, String newPassword) =>
      _repo.changePassword(password, newPassword);
}
