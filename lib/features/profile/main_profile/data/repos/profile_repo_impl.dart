import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/profile/main_profile/data/models/response/get_profile_response.dart';
import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';
import 'package:flowers_app/features/profile/main_profile/domain/repos/profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../core/utils/app_strings.dart';
import '../data_sources/profile_data_source_contract.dart';

@Injectable(as: ProfileRepoContract)
class ProfileRepoImpl implements ProfileRepoContract {
  final ProfileDataSourceContract _dataSource;
  final SecureCacheHelper _secureCacheHelper;

  ProfileRepoImpl(this._dataSource, this._secureCacheHelper);

  @override
  Future<BaseResponse<UserProfileEntity>> getProfileData() async {
    final result = await _dataSource.getProfileData();
    switch (result) {
      case SuccessBaseResponse<GetProfileResponse>():
        if (result.data.user != null) {
          return SuccessBaseResponse<UserProfileEntity>(
            result.data.user!.toEntity(),
          );
        } else {
          return ErrorBaseResponse<UserProfileEntity>(
            AppStrings.profileDataNotFound,
          );
        }
      case ErrorBaseResponse<GetProfileResponse>():
        return ErrorBaseResponse<UserProfileEntity>(result.errorMessage);
    }
  }

  @override
  Future<BaseResponse<void>> logout() async {
    final result = await _dataSource.logout();
    // Always clear local data even if API fails as per team recommendation
    await _secureCacheHelper.deleteData(key: AppKeys.tokenKey);
    return result;
  }
}
