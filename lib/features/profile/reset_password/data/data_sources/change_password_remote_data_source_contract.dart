import 'package:flowers_app/config/base_response/base_response.dart';

abstract interface class ChangePasswordRemoteDataSourceContract {
  Future<BaseResponse<String>> changePassword(
    String password,
    String newPassword,
  );
}
