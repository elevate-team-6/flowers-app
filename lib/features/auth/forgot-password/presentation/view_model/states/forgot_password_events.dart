sealed class ForgotPasswordEvents {}

class ForgotPasswordEvent extends ForgotPasswordEvents {
  final String email;

  ForgotPasswordEvent({required this.email});
}

class VerifyResetCodeEvent extends ForgotPasswordEvents {
  final String email;
  final String resetCode;

  VerifyResetCodeEvent({required this.email, required this.resetCode});
}

class ResetPasswordEvent extends ForgotPasswordEvents {
  final String email;
  final String password;
  final String confirmPassword;

  ResetPasswordEvent({required this.email, required this.password, required this.confirmPassword});
}