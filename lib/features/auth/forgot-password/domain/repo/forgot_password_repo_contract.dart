import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/entites/forget_password_entity.dart';

abstract interface class ForgotPasswordRepoContract {
  Future<BaseResponse<ForgotPasswordEntity>> forgotPassword({
    required String email,
  });

  Future<BaseResponse<ForgotPasswordEntity>> verifyResetCode({
    required String resetCode,
  });

  Future<BaseResponse<ForgotPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  });
}
