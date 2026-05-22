import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/profile/reset_password/api/api_client/change_password_api_client.dart';
import 'package:flowers_app/features/profile/reset_password/data/data_sources/change_password_remote_data_source_contract.dart';
import 'package:flowers_app/features/profile/reset_password/data/models/request/change_password_request.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChangePasswordRemoteDataSourceContract)
class ChangePasswordRemoteDataSourceImpl
    implements ChangePasswordRemoteDataSourceContract {
  final ChangePasswordApiClient _apiClient;
  const ChangePasswordRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<void>> changePassword(
    String password,
    String newPassword,
  ) => ErrorHandler.handleApiCall(
    () => _apiClient.changePassword(
      ChangePasswordRequest(password: password, newPassword: newPassword),
    ),
  );
}
