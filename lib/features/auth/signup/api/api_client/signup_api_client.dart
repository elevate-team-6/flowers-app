import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/data/models/responses/signup_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'signup_api_client.g.dart';

@injectable
@RestApi()
abstract class SignupApiClient {
  @factoryMethod
  factory SignupApiClient(Dio dio) = _SignupApiClient;

  @POST(AppEndPoints.signup)
  Future<SignupResponse> signup(@Body() SignupRequest request);
}
