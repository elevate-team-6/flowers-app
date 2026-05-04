import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/domain/entities/login_entity.dart';

abstract interface class LoginRepoContract {
  Future<BaseResponse<LoginEntity>> login(LoginRequest request);
}
