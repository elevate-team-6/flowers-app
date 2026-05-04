import 'package:dio/dio.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/auth/forgot-password/data/data_sources/forgot_password_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/forgot_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/reset_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/verify_reset_code_request.dart';
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
    try {
      final response = await _remoteDataSource.forgotPassword(
        ForgotPasswordRequest(email: email),
      );
      return SuccessBaseResponse<ForgotPasswordEntity>(response.toEntity());
    } on DioException catch (e) {
      return ErrorBaseResponse<ForgotPasswordEntity>(ErrorHandler.handle(e));
    }
  }

  @override
  Future<BaseResponse<ForgotPasswordEntity>> verifyResetCode({
    required String resetCode,
  }) async {
    try {
      final response = await _remoteDataSource.verifyResetCode(
        VerifyResetCodeRequest(resetCode: resetCode),
      );
      return SuccessBaseResponse<ForgotPasswordEntity>(response.toEntity());
    } on DioException catch (e) {
      return ErrorBaseResponse(ErrorHandler.handle(e));
    }
  }

  @override
  Future<BaseResponse<ForgotPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await _remoteDataSource.resetPassword(
        ResetPasswordRequest(email: email, newPassword: newPassword),
      );
      return SuccessBaseResponse<ForgotPasswordEntity>(response.toEntity());
    } on DioException catch (e) {
      return ErrorBaseResponse<ForgotPasswordEntity>(ErrorHandler.handle(e));
    }
  }
}
