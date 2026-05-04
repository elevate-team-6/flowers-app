import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/login/data/data_sources/login_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/login/data/models/login_request/login_request.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/login_response.dart';
import 'package:flowers_app/features/auth/login/domain/entities/login_entity.dart';
import 'package:flowers_app/features/auth/login/domain/repositories/login_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LoginRepoContract)
class LoginRepoImpl implements LoginRepoContract {
  final LoginRemoteDataSourceContract _loginRemoteDataSource;

  const LoginRepoImpl(this._loginRemoteDataSource);
  @override
  Future<BaseResponse<LoginEntity>> login(LoginRequest request) async {
    final response = await _loginRemoteDataSource.login(request);
    switch (response) {
      case SuccessBaseResponse<LoginResponse>():
        return SuccessBaseResponse(response.data.user!.toEntity());

      case ErrorBaseResponse<LoginResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }
}
