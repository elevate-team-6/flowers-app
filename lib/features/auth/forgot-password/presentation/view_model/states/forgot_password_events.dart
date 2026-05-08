sealed class ForgotPasswordEvents {}

class ForgotPasswordEvent extends ForgotPasswordEvents {
  final String email;

  ForgotPasswordEvent({required this.email});
}

class VerifyResetCodeEvent extends ForgotPasswordEvents {
  final String resetCode;

  VerifyResetCodeEvent({required this.resetCode});
}

class ResetPasswordEvent extends ForgotPasswordEvents {
  final String email;
  final String password;

  ResetPasswordEvent({required this.email, required this.password});
}
