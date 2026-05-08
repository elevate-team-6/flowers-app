import 'package:equatable/equatable.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/entites/forget_password_entity.dart';

class ForgotPasswordStates extends Equatable {
  final BaseState<ForgotPasswordEntity> forgotPasswordState;
  final BaseState<ForgotPasswordEntity> verifyResetCodeState;
  final BaseState<ForgotPasswordEntity> resetPasswordState;

  // 1. Const constructor
  // 2. Default values are now 'const BaseState()'
  const ForgotPasswordStates({
    this.forgotPasswordState = const BaseState(),
    this.verifyResetCodeState = const BaseState(),
    this.resetPasswordState = const BaseState(),
  });

  ForgotPasswordStates copyWith({
    BaseState<ForgotPasswordEntity>? forgotPasswordStateParam,
    BaseState<ForgotPasswordEntity>? verifyResetCodeStateParam,
    BaseState<ForgotPasswordEntity>? resetPasswordStateParam,
  }) => ForgotPasswordStates(
    forgotPasswordState: forgotPasswordStateParam ?? forgotPasswordState,
    verifyResetCodeState: verifyResetCodeStateParam ?? verifyResetCodeState,
    resetPasswordState: resetPasswordStateParam ?? resetPasswordState,
  );

  @override
  List<Object?> get props => [
    forgotPasswordState,
    verifyResetCodeState,
    resetPasswordState,
  ];
}
