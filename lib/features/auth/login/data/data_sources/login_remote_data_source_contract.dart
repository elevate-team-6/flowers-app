import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/login_response.dart';

abstract interface class LoginRemoteDataSourceContract {
  Future<BaseResponse<LoginResponse>> login(LoginRequest request);
}
