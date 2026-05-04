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
  Future<ForgotPasswordResponse> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    return await _forgotPasswordApiClient.forgotPassword(request);
  }

  @override
  Future<VerifyResetCodeResponse> verifyResetCode(
    VerifyResetCodeRequest request,
  ) async {
    return await _forgotPasswordApiClient.verifyResetCode(request);
  }

  @override
  Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequest request,
  ) async {
    return await _forgotPasswordApiClient.resetPassword(request);
  }
}
