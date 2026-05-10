import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:flowers_app/features/auth/login/domain/repositories/login_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class LoginUseCase {
  final LoginRepoContract _loginRepo;
  const LoginUseCase(this._loginRepo);
  Future<BaseResponse<UserEntity>> call(LoginRequest request) {
    return _loginRepo.login(request);
  }
}
