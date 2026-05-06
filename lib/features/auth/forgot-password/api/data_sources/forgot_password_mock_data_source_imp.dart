import 'dart:async';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/data_sources/forgot_password_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/forgot_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/reset_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/verify_reset_code_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/forgot_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/reset_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/verify_reset_code_response.dart';
// import 'package:injectable/injectable.dart';

// @Injectable(as: ForgotPasswordRemoteDataSourceContract)
class ForgotPasswordMockDataSourceImpl
    implements ForgotPasswordRemoteDataSourceContract {
  /// simulate network delay
  Future<T> _simulate<T>(T response) async {
    await Future.delayed(const Duration(seconds: 1));
    return response;
  }

  @override
  Future<BaseResponse<ForgotPasswordResponse>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    /// fake validation
    if (request.email.contains('@')) {
      return _simulate(
        SuccessBaseResponse(
          ForgotPasswordResponse(
            message: 'OTP sent successfully',
            info: 'Check your email',
            statusMsg: 'success',
          ),
        ),
      );
    } else {
      return _simulate(ErrorBaseResponse('Invalid email address'));
    }
  }

  @override
  Future<BaseResponse<VerifyResetCodeResponse>> verifyResetCode(
    VerifyResetCodeRequest request,
  ) async {
    /// fake OTP = 123456
    if (request.resetCode == '123456') {
      return _simulate(
        SuccessBaseResponse(
          VerifyResetCodeResponse(status: 'Success', message: 'Code verified'),
        ),
      );
    } else {
      return _simulate(ErrorBaseResponse('Invalid or expired OTP'));
    }
  }

  @override
  Future<BaseResponse<ResetPasswordResponse>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    /// fake password rule
    if (request.newPassword.length >= 6) {
      return _simulate(
        SuccessBaseResponse(
          ResetPasswordResponse(
            message: 'Password reset successfully',
            token: 'mock_token_123456',
          ),
        ),
      );
    } else {
      return _simulate(ErrorBaseResponse('Password too weak'));
    }
  }
}
