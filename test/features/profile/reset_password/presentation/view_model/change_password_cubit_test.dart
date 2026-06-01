import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/profile/reset_password/domain/use_cases/change_password_use_case.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_cubit.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_event.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_cubit_test.mocks.dart';

@GenerateMocks([ChangePasswordUseCase, SecureCacheHelper])
void main() {
  late MockChangePasswordUseCase changePasswordUseCase;
  late MockSecureCacheHelper secureCacheHelper;

  setUpAll(() {
    provideDummy<BaseResponse<String>>(ErrorBaseResponse<String>('dummy'));
  });

  setUp(() {
    changePasswordUseCase = MockChangePasswordUseCase();
    secureCacheHelper = MockSecureCacheHelper();
  });

  ChangePasswordCubit buildCubit() =>
      ChangePasswordCubit(changePasswordUseCase, secureCacheHelper);

  const currentPassword = 'OldPass@123';
  const newPassword = 'NewPass@123';
  const token = 'new_token_123';

  group('ChangePasswordEvent', () {
    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits [loading, success] and saves new token when changePassword succeeds',
      setUp: () {
        when(
          changePasswordUseCase(currentPassword, newPassword),
        ).thenAnswer((_) async => SuccessBaseResponse<String>(token));
        when(
          secureCacheHelper.writeData(
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async {});
      },
      build: buildCubit,
      act: (cubit) => cubit.doEvent(
        ChangePasswordEvent(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ),
      expect: () => [
        const ChangePasswordState(status: ChangePasswordStatus.loading),
        const ChangePasswordState(status: ChangePasswordStatus.success),
      ],
      verify: (_) {
        verify(changePasswordUseCase(currentPassword, newPassword)).called(1);
        // الـ token الجديد اتحفظ
        verify(
          secureCacheHelper.writeData(key: AppKeys.tokenKey, value: token),
        ).called(1);
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits [loading, failure] when changePassword fails',
      setUp: () {
        when(
          changePasswordUseCase(currentPassword, newPassword),
        ).thenAnswer((_) async => ErrorBaseResponse<String>('Error'));
      },
      build: buildCubit,
      act: (cubit) => cubit.doEvent(
        ChangePasswordEvent(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ),
      expect: () => [
        const ChangePasswordState(status: ChangePasswordStatus.loading),
        const ChangePasswordState(
          status: ChangePasswordStatus.failure,
          errorMessage: 'Error',
        ),
      ],
      verify: (_) {
        verify(changePasswordUseCase(currentPassword, newPassword)).called(1);
        // الـ token مايتحفظش لو فشل
        verifyNever(
          secureCacheHelper.writeData(
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        );
      },
    );
  });
}
