import 'package:flowers_app/features/auth/signup/data/models/responses/signup_response.dart';
import 'package:flowers_app/features/auth/signup/domain/repositories/signup_repo_contract.dart';
import 'package:injectable/injectable.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/auth/signup/data/data_sources/signup_remote_data_source_contract.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/domain/entities/user_entity.dart';

@Injectable(as: SignupRepoContract)
class SignupRepoImpl implements SignupRepoContract {
  final SignupRemoteDataSourceContract _signupDataSource;
  const SignupRepoImpl(this._signupDataSource);

  @override
  Future<BaseResponse<UserEntity>> signup(SignupRequest request) async {
    final response = await _signupDataSource.signup(request);

    switch (response) {
      case SuccessBaseResponse<SignupResponse>():
        return SuccessBaseResponse(response.data.user!.toEntity());
      case ErrorBaseResponse<SignupResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }
}
