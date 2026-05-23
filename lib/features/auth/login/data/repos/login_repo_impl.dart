import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/auth/login/data/data_sources/login_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/login_response.dart';
import 'package:flowers_app/features/auth/login/domain/entities/user_entity.dart';
import 'package:flowers_app/features/auth/login/domain/repositories/login_repo_contract.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_localization/easy_localization.dart';

@Injectable(as: LoginRepoContract)
class LoginRepoImpl implements LoginRepoContract {
  final LoginRemoteDataSourceContract _loginRemoteDataSource;

  const LoginRepoImpl(this._loginRemoteDataSource);
  @override
  Future<BaseResponse<UserEntity>> login(LoginRequest request) async {
    final response = await _loginRemoteDataSource.login(request);
    switch (response) {
      case SuccessBaseResponse<LoginResponse>():
        final data = response.data;
        if (data.user == null) {
          return ErrorBaseResponse(AppStrings.someThingWentWrong.tr());
        }
        final user = data.user!;
        return SuccessBaseResponse(
          UserEntity(
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            gender: user.gender,
            phone: user.phone,
            photo: user.photo,
            role: user.role,
            createdAt: user.createdAt,
            token: data.token,
          ),
        );
      case ErrorBaseResponse<LoginResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }
}
