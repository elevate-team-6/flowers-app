import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/main_profile/data/models/response/get_profile_response.dart';

abstract interface class ProfileDataSourceContract {
  Future<BaseResponse<GetProfileResponse>> getProfileData();
}
