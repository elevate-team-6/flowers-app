import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/entites/forget_password_entity.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/forgot_password_use_cases/forgot_password_use_case.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/forgot_password_use_cases/reset_password_use_case.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/forgot_password_use_cases/verify_reset_code_use_case.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/cubit/forgot_password_view_model.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/states/forgot_password_events.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/states/forgot_password_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forgot_password_view_model_test.mocks.dart';

@GenerateMocks([
  ForgotPasswordUseCase,
  VerifyResetCodeUseCase,
  ResetPasswordUseCase,
])
void main() {
  // Arrange
  late ForgotPasswordViewModel forgotPasswordViewModel;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;
  late MockVerifyResetCodeUseCase mockVerifyResetCodeUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;
  late ForgotPasswordEntity forgotPasswordEntity;
  late String errMsg;

  setUpAll(() {
    errMsg = "Something went wrong. Please try again later.";
    forgotPasswordEntity = ForgotPasswordEntity(
      message: 'OTP sent successfully',
      info: 'Check your email',
      statusMsg: 'success',
    );

    provideDummy<BaseResponse<ForgotPasswordEntity>>(
      SuccessBaseResponse<ForgotPasswordEntity>(ForgotPasswordEntity()),
    );
  });

  setUp(() {
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    mockVerifyResetCodeUseCase = MockVerifyResetCodeUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    forgotPasswordViewModel = ForgotPasswordViewModel(
      mockForgotPasswordUseCase,
      mockVerifyResetCodeUseCase,
      mockResetPasswordUseCase,
    );
  });

  group("Forgot Password View Model Test Group", () {
    group("Forgot Password Event", () {
      blocTest<ForgotPasswordViewModel, ForgotPasswordStates>(
        'emits [loading, success] when forgotPassword succeeds',
        build: () => forgotPasswordViewModel,
        act: (cubit) {
          when(
            mockForgotPasswordUseCase.call(email: 'test@example.com'),
          ).thenAnswer(
            (_) async =>
                SuccessBaseResponse<ForgotPasswordEntity>(forgotPasswordEntity),
          );
          cubit.doEvent(ForgotPasswordEvent(email: 'test@example.com'));
        },
        expect: () => [
          ForgotPasswordStates(
            forgotPasswordState: BaseState<ForgotPasswordEntity>(
              isLoading: true,
            ),
          ),
          ForgotPasswordStates(
            forgotPasswordState: BaseState<ForgotPasswordEntity>(
              data: forgotPasswordEntity,
            ),
          ),
        ],
        verify: (_) {
          verify(
            mockForgotPasswordUseCase.call(email: 'test@example.com'),
          ).called(1);
        },
      );

      blocTest<ForgotPasswordViewModel, ForgotPasswordStates>(
        'emits [loading, error] when forgotPassword fails',
        build: () => forgotPasswordViewModel,
        act: (cubit) {
          when(
            mockForgotPasswordUseCase.call(email: 'test@example.com'),
          ).thenAnswer(
            (_) async => ErrorBaseResponse<ForgotPasswordEntity>(errMsg),
          );
          cubit.doEvent(ForgotPasswordEvent(email: 'test@example.com'));
        },
        expect: () => [
          ForgotPasswordStates(
            forgotPasswordState: BaseState<ForgotPasswordEntity>(
              isLoading: true,
            ),
          ),
          ForgotPasswordStates(
            forgotPasswordState: BaseState<ForgotPasswordEntity>(
              errorMessage: errMsg,
            ),
          ),
        ],
        verify: (_) {
          verify(
            mockForgotPasswordUseCase.call(email: 'test@example.com'),
          ).called(1);
        },
      );
    });

    group("Verify Reset Code Event", () {
      blocTest<ForgotPasswordViewModel, ForgotPasswordStates>(
        'emits [loading, success] when verifyResetCode succeeds',
        build: () => forgotPasswordViewModel,
        act: (cubit) {
          when(mockVerifyResetCodeUseCase.call(resetCode: '123456')).thenAnswer(
            (_) async =>
                SuccessBaseResponse<ForgotPasswordEntity>(forgotPasswordEntity),
          );
          cubit.doEvent(VerifyResetCodeEvent(resetCode: '123456'));
        },
        expect: () => [
          ForgotPasswordStates(
            verifyResetCodeState: BaseState<ForgotPasswordEntity>(
              isLoading: true,
            ),
          ),
          ForgotPasswordStates(
            verifyResetCodeState: BaseState<ForgotPasswordEntity>(
              data: forgotPasswordEntity,
            ),
          ),
        ],
        verify: (_) {
          verify(
            mockVerifyResetCodeUseCase.call(resetCode: '123456'),
          ).called(1);
        },
      );

      blocTest<ForgotPasswordViewModel, ForgotPasswordStates>(
        'emits [loading, error] when verifyResetCode fails',
        build: () => forgotPasswordViewModel,
        act: (cubit) {
          when(mockVerifyResetCodeUseCase.call(resetCode: '123456')).thenAnswer(
            (_) async => ErrorBaseResponse<ForgotPasswordEntity>(errMsg),
          );
          cubit.doEvent(VerifyResetCodeEvent(resetCode: '123456'));
        },
        expect: () => [
          ForgotPasswordStates(
            verifyResetCodeState: BaseState<ForgotPasswordEntity>(
              isLoading: true,
            ),
          ),
          ForgotPasswordStates(
            verifyResetCodeState: BaseState<ForgotPasswordEntity>(
              errorMessage: errMsg,
            ),
          ),
        ],
        verify: (_) {
          verify(
            mockVerifyResetCodeUseCase.call(resetCode: '123456'),
          ).called(1);
        },
      );
    });

    group("Reset Password Event", () {
      blocTest<ForgotPasswordViewModel, ForgotPasswordStates>(
        'emits [loading, success] when resetPassword succeeds',
        build: () => forgotPasswordViewModel,
        act: (cubit) {
          when(
            mockResetPasswordUseCase.call(
              email: 'test@example.com',
              newPassword: 'newpass',
            ),
          ).thenAnswer(
            (_) async =>
                SuccessBaseResponse<ForgotPasswordEntity>(forgotPasswordEntity),
          );
          cubit.doEvent(
            ResetPasswordEvent(email: 'test@example.com', password: 'newpass'),
          );
        },
        expect: () => [
          ForgotPasswordStates(
            resetPasswordState: BaseState<ForgotPasswordEntity>(
              isLoading: true,
            ),
          ),
          ForgotPasswordStates(
            resetPasswordState: BaseState<ForgotPasswordEntity>(
              data: forgotPasswordEntity,
            ),
          ),
        ],
        verify: (_) {
          verify(
            mockResetPasswordUseCase.call(
              email: 'test@example.com',
              newPassword: 'newpass',
            ),
          ).called(1);
        },
      );

      blocTest<ForgotPasswordViewModel, ForgotPasswordStates>(
        'emits [loading, error] when resetPassword fails',
        build: () => forgotPasswordViewModel,
        act: (cubit) {
          when(
            mockResetPasswordUseCase.call(
              email: 'test@example.com',
              newPassword: 'newpass',
            ),
          ).thenAnswer(
            (_) async => ErrorBaseResponse<ForgotPasswordEntity>(errMsg),
          );
          cubit.doEvent(
            ResetPasswordEvent(email: 'test@example.com', password: 'newpass'),
          );
        },
        expect: () => [
          ForgotPasswordStates(
            resetPasswordState: BaseState<ForgotPasswordEntity>(
              isLoading: true,
            ),
          ),
          ForgotPasswordStates(
            resetPasswordState: BaseState<ForgotPasswordEntity>(
              errorMessage: errMsg,
            ),
          ),
        ],
        verify: (_) {
          verify(
            mockResetPasswordUseCase.call(
              email: 'test@example.com',
              newPassword: 'newpass',
            ),
          ).called(1);
        },
      );
    });
  });
}
