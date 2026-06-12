class ForgotPasswordEntity {
  // forgot password response fields
  final String? message;
  final String? info;
  final String? statusMsg;

  // verify reset code response fields
  final String? status;
  // reset password response fields
  final String? token;

  const ForgotPasswordEntity({
    this.message,
    this.info,
    this.statusMsg,
    this.status,
    this.token,
  });
}
