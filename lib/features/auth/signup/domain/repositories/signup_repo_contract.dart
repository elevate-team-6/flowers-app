import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/domain/entities/user_entity.dart';

abstract interface class SignupRepoContract {
  Future<BaseResponse<UserEntity>> signup(SignupRequest request);
}