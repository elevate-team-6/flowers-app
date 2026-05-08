import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/login_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'login_api_client.g.dart';

@injectable
@RestApi()
abstract class LoginApiClient {
  @factoryMethod
  factory LoginApiClient(Dio dio) => _LoginApiClient(dio);
  @POST(AppEndPoints.signin)
  Future<LoginResponse> login(@Body() LoginRequest request);
}
