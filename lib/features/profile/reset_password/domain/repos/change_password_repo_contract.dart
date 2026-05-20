import 'package:flowers_app/config/base_response/base_response.dart';

abstract interface class ChangePasswordRepoContract {
  Future<BaseResponse<void>> changePassword(
    String password,
    String newPassword,
  );
}
