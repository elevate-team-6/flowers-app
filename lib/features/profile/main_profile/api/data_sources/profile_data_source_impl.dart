import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources/profile_data_source_contract.dart';
import '../../data/models/response/get_profile_response.dart';
import '../api_client/profile_api_client.dart';

@Injectable(as: ProfileDataSourceContract)
class ProfileDataSourceImpl implements ProfileDataSourceContract {
  final ProfileApiClient _apiClient;

  ProfileDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<GetProfileResponse>> getProfileData() async {
    return await ErrorHandler.handleApiCall(() => _apiClient.getProfileData());
  }
}
