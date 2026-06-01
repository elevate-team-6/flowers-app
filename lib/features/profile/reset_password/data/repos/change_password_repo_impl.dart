import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/reset_password/data/data_sources/change_password_remote_data_source_contract.dart';
import 'package:flowers_app/features/profile/reset_password/domain/repos/change_password_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChangePasswordRepoContract)
class ChangePasswordRepoImpl implements ChangePasswordRepoContract {
  final ChangePasswordRemoteDataSourceContract _dataSource;
  const ChangePasswordRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<String>> changePassword(
    String password,
    String newPassword,
  ) => _dataSource.changePassword(password, newPassword);
}
