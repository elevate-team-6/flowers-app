import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/forgot_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/reset_password_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/request/verify_reset_code_request.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/forgot_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/reset_password_response.dart';
import 'package:flowers_app/features/auth/forgot-password/data/models/response/verify_reset_code_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'forgot_password_api_client.g.dart';

@injectable
@RestApi(baseUrl: AppEndPoints.baseUrl)
abstract class ForgotPasswordApiClient {
  @factoryMethod
  factory ForgotPasswordApiClient(Dio dio) = _ForgotPasswordApiClient;

  @POST(AppEndPoints.forgetPassword)
  Future<ForgotPasswordResponse> forgotPassword(
    @Body() ForgotPasswordRequest request,
  );

  @POST(AppEndPoints.verifyResetCode)
  Future<VerifyResetCodeResponse> verifyResetCode(
    @Body() VerifyResetCodeRequest request,
  );

  @PUT(AppEndPoints.resetPassword)
  Future<ResetPasswordResponse> resetPassword(
    @Body() ResetPasswordRequest request,
  );
}
