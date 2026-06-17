import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/auth/login/api/api_client/login_api_client.dart';
import 'package:flowers_app/features/auth/login/data/data_sources/login_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/login_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginRemoteDataSourceContract)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSourceContract {
  final LoginApiClient _loginApiClient;

  const LoginRemoteDataSourceImpl(this._loginApiClient);

  @override
  Future<BaseResponse<LoginResponse>> login(LoginRequest request) {
    return ErrorHandler.handleApiCall(() {
      return _loginApiClient.login(request);
    });
  }
}
