import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/auth/forgot-password/api/api_client/forgot_password_api_client.dart';
import 'package:flowers_app/features/auth/forgot-password/data/data_sources/forgot_password_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/forgot_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/reset_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/verify_reset_code_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/forgot_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/reset_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/verify_reset_code_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ForgotPasswordRemoteDataSourceContract)
class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSourceContract {
  final ForgotPasswordApiClient _forgotPasswordApiClient;

  ForgotPasswordRemoteDataSourceImpl(this._forgotPasswordApiClient);

  @override
  Future<BaseResponse<ForgotPasswordResponse>> forgotPassword(
    ForgotPasswordRequest request,
  ) {
    return ErrorHandler.executeApiCall(
      () => _forgotPasswordApiClient.forgotPassword(request),
    );
  }

  @override
  Future<BaseResponse<VerifyResetCodeResponse>> verifyResetCode(
    VerifyResetCodeRequest request,
  ) {
    return ErrorHandler.executeApiCall(
      () => _forgotPasswordApiClient.verifyResetCode(request),
    );
  }

  @override
  Future<BaseResponse<ResetPasswordResponse>> resetPassword(
    ResetPasswordRequest request,
  ) {
    return ErrorHandler.executeApiCall(
      () => _forgotPasswordApiClient.resetPassword(request),
    );
  }
}
