import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';

abstract interface class ProfileRepoContract {
  Future<BaseResponse<UserProfileEntity>> getProfileData();
  Future<BaseResponse<void>> logout();
}
