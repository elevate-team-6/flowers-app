import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/reset_password/data/data_sources/change_password_remote_data_source_contract.dart';
import 'package:flowers_app/features/profile/reset_password/data/repos/change_password_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_repo_impl_test.mocks.dart';

@GenerateMocks([ChangePasswordRemoteDataSourceContract])
void main() {
  late MockChangePasswordRemoteDataSourceContract dataSource;
  late ChangePasswordRepoImpl repo;

  setUpAll(() {
    provideDummy<BaseResponse<String>>(ErrorBaseResponse<String>('dummy'));
  });

  setUp(() {
    dataSource = MockChangePasswordRemoteDataSourceContract();
    repo = ChangePasswordRepoImpl(dataSource);
  });

  const currentPassword = 'OldPass@123';
  const newPassword = 'NewPass@123';
  const token = 'new_token_123';

  group('changePassword', () {
    test('returns SuccessBaseResponse with token when success', () async {
      when(
        dataSource.changePassword(currentPassword, newPassword),
      ).thenAnswer((_) async => SuccessBaseResponse<String>(token));

      final result = await repo.changePassword(currentPassword, newPassword);

      expect(result, isA<SuccessBaseResponse<String>>());
      expect((result as SuccessBaseResponse).data, token);
      verify(dataSource.changePassword(currentPassword, newPassword)).called(1);
    });

    test('returns ErrorBaseResponse with message when failure', () async {
      when(
        dataSource.changePassword(currentPassword, newPassword),
      ).thenAnswer((_) async => ErrorBaseResponse<String>('Error'));

      final result = await repo.changePassword(currentPassword, newPassword);

      expect(result, isA<ErrorBaseResponse<String>>());
      expect((result as ErrorBaseResponse).errorMessage, 'Error');
    });
  });
}
