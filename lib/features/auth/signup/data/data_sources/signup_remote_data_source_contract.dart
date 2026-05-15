import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/data/models/responses/signup_response.dart';

abstract interface class SignupRemoteDataSourceContract {
  Future<BaseResponse<SignupResponse>> signup(SignupRequest request);
}
