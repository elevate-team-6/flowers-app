import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/data_sources/forgot_password_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/forgot_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/reset_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/verify_reset_code_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/forgot_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/reset_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/verify_reset_code_response.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/entites/forget_password_entity.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/repo/forgot_password_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ForgotPasswordRepoContract)
class ForgotPasswordRepoImpl implements ForgotPasswordRepoContract {
  final ForgotPasswordRemoteDataSourceContract _remoteDataSource;

  ForgotPasswordRepoImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<ForgotPasswordEntity>> forgotPassword({
    required String email,
  }) async {
    final response = await _remoteDataSource.forgotPassword(
      ForgotPasswordRequest(email: email),
    );
    switch (response) {
      case SuccessBaseResponse<ForgotPasswordResponse>():
        return SuccessBaseResponse<ForgotPasswordEntity>(
          response.data.toEntity(),
        );
      case ErrorBaseResponse<ForgotPasswordResponse>():
        return ErrorBaseResponse<ForgotPasswordEntity>(response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<ForgotPasswordEntity>> verifyResetCode({
    required String resetCode,
  }) async {
    final response = await _remoteDataSource.verifyResetCode(
      VerifyResetCodeRequest(resetCode: resetCode),
    );
    switch (response) {
      case SuccessBaseResponse<VerifyResetCodeResponse>():
        return SuccessBaseResponse<ForgotPasswordEntity>(
          response.data.toEntity(),
        );
      case ErrorBaseResponse<VerifyResetCodeResponse>():
        return ErrorBaseResponse<ForgotPasswordEntity>(response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<ForgotPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final response = await _remoteDataSource.resetPassword(
      ResetPasswordRequest(email: email, newPassword: newPassword),
    );
    switch (response) {
      case SuccessBaseResponse<ResetPasswordResponse>():
        return SuccessBaseResponse<ForgotPasswordEntity>(
          response.data.toEntity(),
        );
      case ErrorBaseResponse<ResetPasswordResponse>():
        return ErrorBaseResponse<ForgotPasswordEntity>(response.errorMessage);
    }
  }
}
