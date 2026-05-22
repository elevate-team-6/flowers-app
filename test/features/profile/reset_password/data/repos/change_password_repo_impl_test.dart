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
    provideDummy<BaseResponse<void>>(ErrorBaseResponse<void>('dummy'));
  });

  setUp(() {
    dataSource = MockChangePasswordRemoteDataSourceContract();
    repo = ChangePasswordRepoImpl(dataSource);
  });

  const currentPassword = 'OldPass@123';
  const newPassword = 'NewPass@123';

  group('changePassword', () {
    test('returns SuccessBaseResponse when success', () async {
      when(
        dataSource.changePassword(currentPassword, newPassword),
      ).thenAnswer((_) async => SuccessBaseResponse<void>(null));

      final result = await repo.changePassword(currentPassword, newPassword);

      expect(result, isA<SuccessBaseResponse<void>>());
      verify(dataSource.changePassword(currentPassword, newPassword)).called(1);
    });

    test('returns ErrorBaseResponse when failure', () async {
      when(
        dataSource.changePassword(currentPassword, newPassword),
      ).thenAnswer((_) async => ErrorBaseResponse<void>('Error'));

      final result = await repo.changePassword(currentPassword, newPassword);

      expect(result, isA<ErrorBaseResponse<void>>());
      expect((result as ErrorBaseResponse).errorMessage, 'Error');
    });
  });
}
