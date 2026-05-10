import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/entites/forget_password_entity.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/repo/forgot_password_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class VerifyResetCodeUseCase {
  final ForgotPasswordRepoContract _repository;

  VerifyResetCodeUseCase(this._repository);

  Future<BaseResponse<ForgotPasswordEntity>> call({required String resetCode}) {
    return _repository.verifyResetCode(resetCode: resetCode);
  }
}
