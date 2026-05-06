import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/entites/forget_password_entity.dart';

class ForgotPasswordStates extends Equatable {
  final BaseState<ForgotPasswordEntity> forgotPasswordState;
  final BaseState<ForgotPasswordEntity> verifyResetCodeState;
  final BaseState<ForgotPasswordEntity> resetPasswordState;

  ForgotPasswordStates({
    BaseState<ForgotPasswordEntity>? forgotPasswordState,
    BaseState<ForgotPasswordEntity>? verifyResetCodeState,
    BaseState<ForgotPasswordEntity>? resetPasswordState,
  })
    : forgotPasswordState = forgotPasswordState ?? BaseState<ForgotPasswordEntity>(isLoading: false),
      verifyResetCodeState = verifyResetCodeState ?? BaseState<ForgotPasswordEntity>(isLoading: false),
      resetPasswordState = resetPasswordState ?? BaseState<ForgotPasswordEntity>(isLoading: false);

  ForgotPasswordStates copyWith({
    BaseState<ForgotPasswordEntity>? forgotPasswordStateParam,
    BaseState<ForgotPasswordEntity>? verifyResetCodeStateParam,
    BaseState<ForgotPasswordEntity>? resetPasswordStateParam,
  }) =>
      ForgotPasswordStates(
        forgotPasswordState: forgotPasswordStateParam ?? forgotPasswordState,
        verifyResetCodeState: verifyResetCodeStateParam ?? verifyResetCodeState,
        resetPasswordState: resetPasswordStateParam ?? resetPasswordState,
      );

  @override
  List<Object?> get props => [forgotPasswordState, verifyResetCodeState, resetPasswordState];
}