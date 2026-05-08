import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/domain/entities/user_entity.dart';

abstract interface class LoginRepoContract {
  Future<BaseResponse<UserEntity>> login(LoginRequest request);
}
