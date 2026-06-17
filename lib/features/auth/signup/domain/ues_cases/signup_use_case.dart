import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:injectable/injectable.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/signup/domain/entities/user_entity.dart';
import 'package:flowers_app/features/auth/signup/domain/repositories/signup_repo_contract.dart';

@injectable
class SignupUseCase {
  final SignupRepoContract _repo;
  const SignupUseCase(this._repo);

  Future<BaseResponse<UserEntity>> call(SignupRequest request) =>
      _repo.signup(request);
}
