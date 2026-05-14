import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/auth/signup/data/data_sources/signup_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/data/models/responses/signup_response.dart';
import 'package:injectable/injectable.dart';
import 'package:flowers_app/features/auth/signup/api/api_client/signup_api_client.dart';

@Injectable(as: SignupRemoteDataSourceContract)
class SignupRemoteDataSourceImpl implements SignupRemoteDataSourceContract {
  final SignupApiClient _signupApiClient;
  const SignupRemoteDataSourceImpl(this._signupApiClient);

  @override
  Future<BaseResponse<SignupResponse>> signup(SignupRequest request) async {
    return ErrorHandler.executeApiCall(() {
      return _signupApiClient.signup(request);
    });
  }
}
