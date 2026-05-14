class ResetPasswordRequest {
  final String email;
  final String newPassword;

  const ResetPasswordRequest({required this.email, required this.newPassword});

  Map<String, dynamic> toJson() => {'email': email, 'newPassword': newPassword};
}
