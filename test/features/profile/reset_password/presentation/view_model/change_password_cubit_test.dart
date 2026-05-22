import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/profile/reset_password/domain/use_cases/change_password_use_case.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_cubit.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_event.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_cubit_test.mocks.dart';

@GenerateMocks([ChangePasswordUseCase])
void main() {
  late MockChangePasswordUseCase changePasswordUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<void>>(ErrorBaseResponse<void>('dummy'));
  });

  setUp(() {
    changePasswordUseCase = MockChangePasswordUseCase();
  });

  ChangePasswordCubit buildCubit() =>
      ChangePasswordCubit(changePasswordUseCase);

  const currentPassword = 'OldPass@123';
  const newPassword = 'NewPass@123';

  group('ChangePasswordEvent', () {
    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits [loading, success] when changePassword succeeds',
      build: () {
        when(
          changePasswordUseCase(currentPassword, newPassword),
        ).thenAnswer((_) async => SuccessBaseResponse<void>(null));
        return buildCubit();
      },
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
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits [loading, failure] when changePassword fails',
      build: () {
        when(
          changePasswordUseCase(currentPassword, newPassword),
        ).thenAnswer((_) async => ErrorBaseResponse<void>('Error'));
        return buildCubit();
      },
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
      },
    );
  });
}
