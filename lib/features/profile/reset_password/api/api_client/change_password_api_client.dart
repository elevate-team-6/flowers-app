import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/profile/reset_password/data/models/response/change_password_response.dart';
import 'package:flowers_app/features/profile/reset_password/data/models/request/change_password_request.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'change_password_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class ChangePasswordApiClient {
  @factoryMethod
  factory ChangePasswordApiClient(Dio dio) = _ChangePasswordApiClient;

  @PATCH(AppEndPoints.changePassword)
  Future<ChangePasswordResponse> changePassword(
    @Body() ChangePasswordRequest request,
  );
}
