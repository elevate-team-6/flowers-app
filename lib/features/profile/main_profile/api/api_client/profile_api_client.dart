import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/models/response/get_profile_response.dart';

part 'profile_api_client.g.dart';

@injectable
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET(AppEndPoints.profileData)
  //todo: how much duration to cache the data
  @Extra({AppKeys.cacheDurationHours: 24})
  Future<GetProfileResponse> getProfileData();

  @GET(AppEndPoints.logout)
  Future<void> logout();
}
