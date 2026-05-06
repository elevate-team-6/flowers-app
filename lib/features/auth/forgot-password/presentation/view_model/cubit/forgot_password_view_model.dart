import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/entites/forget_password_entity.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/forgot_password_use_cases/forgot_password_use_case.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/forgot_password_use_cases/reset_password_use_case.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/forgot_password_use_cases/verify_reset_code_use_case.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/states/forgot_password_events.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/states/forgot_password_states.dart';

@injectable
class ForgotPasswordViewModel extends Cubit<ForgotPasswordStates> {
  ForgotPasswordViewModel(
    this.forgotPasswordUseCase,
    this.verifyResetCodeUseCase,
    this.resetPasswordUseCase,
  ) : super(ForgotPasswordStates());

  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyResetCodeUseCase verifyResetCodeUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  void doEvent(ForgotPasswordEvents event) async {
    switch (event) {
      case ForgotPasswordEvent(email: final email):
        await _forgotPassword(email);
        break;
      case VerifyResetCodeEvent(email: final email, resetCode: final resetCode):
        await _verifyResetCode(resetCode);
        break;
      case ResetPasswordEvent(
        email: final email,
        password: final password,
        confirmPassword: final confirmPassword,
      ):
        await _resetPassword(email, password);
        break;
    }
  }

  Future<void> _forgotPassword(String email) async {
    emit(
      state.copyWith(
        forgotPasswordStateParam: BaseState<ForgotPasswordEntity>(
          isLoading: true,
        ),
      ),
    );

    final result = await forgotPasswordUseCase.call(email: email);

    switch (result) {
      case SuccessBaseResponse<ForgotPasswordEntity>():
        log(result.data.toString());
        emit(
          state.copyWith(
            forgotPasswordStateParam: BaseState<ForgotPasswordEntity>(
              data: result.data,
            ),
          ),
        );
      case ErrorBaseResponse<ForgotPasswordEntity>():
        emit(
          state.copyWith(
            forgotPasswordStateParam: BaseState<ForgotPasswordEntity>(
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _verifyResetCode(String resetCode) async {
    emit(
      state.copyWith(
        verifyResetCodeStateParam: BaseState<ForgotPasswordEntity>(
          isLoading: true,
        ),
      ),
    );

    final result = await verifyResetCodeUseCase.call(resetCode: resetCode);

    switch (result) {
      case SuccessBaseResponse<ForgotPasswordEntity>():
        log(result.data.toString());
        emit(
          state.copyWith(
            verifyResetCodeStateParam: BaseState<ForgotPasswordEntity>(
              data: result.data,
            ),
          ),
        );
      case ErrorBaseResponse<ForgotPasswordEntity>():
        emit(
          state.copyWith(
            verifyResetCodeStateParam: BaseState<ForgotPasswordEntity>(
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _resetPassword(String email, String password) async {
    emit(
      state.copyWith(
        resetPasswordStateParam: BaseState<ForgotPasswordEntity>(
          isLoading: true,
        ),
      ),
    );

    final result = await resetPasswordUseCase.call(
      email: email,
      newPassword: password,
    );

    switch (result) {
      case SuccessBaseResponse<ForgotPasswordEntity>():
        log(result.data.toString());
        emit(
          state.copyWith(
            resetPasswordStateParam: BaseState<ForgotPasswordEntity>(
              data: result.data,
            ),
          ),
        );
      case ErrorBaseResponse<ForgotPasswordEntity>():
        emit(
          state.copyWith(
            resetPasswordStateParam: BaseState<ForgotPasswordEntity>(
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }
}
