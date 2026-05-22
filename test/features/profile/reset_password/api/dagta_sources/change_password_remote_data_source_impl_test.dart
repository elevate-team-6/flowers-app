import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/reset_password/api/api_client/change_password_api_client.dart';
import 'package:flowers_app/features/profile/reset_password/api/data_sources/change_password_remote_data_source_impl.dart';
import 'package:flowers_app/features/profile/reset_password/data/models/request/change_password_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ChangePasswordApiClient])
void main() {
  late MockChangePasswordApiClient apiClient;
  late ChangePasswordRemoteDataSourceImpl dataSource;

  setUp(() {
    apiClient = MockChangePasswordApiClient();
    dataSource = ChangePasswordRemoteDataSourceImpl(apiClient);
  });

  const currentPassword = 'OldPass@123';
  const newPassword = 'NewPass@123';

  group('changePassword', () {
    test('returns SuccessBaseResponse when API call succeeds', () async {
      when(
        apiClient.changePassword(any),
      ).thenAnswer((_) async => Future.value());

      final result = await dataSource.changePassword(
        currentPassword,
        newPassword,
      );

      expect(result, isA<SuccessBaseResponse<void>>());
      verify(
        apiClient.changePassword(argThat(isA<ChangePasswordRequest>())),
      ).called(1);
    });

    test('returns ErrorBaseResponse when API call throws', () async {
      when(apiClient.changePassword(any)).thenThrow(Exception('error'));

      final result = await dataSource.changePassword(
        currentPassword,
        newPassword,
      );

      expect(result, isA<ErrorBaseResponse<void>>());
    });
  });
}
