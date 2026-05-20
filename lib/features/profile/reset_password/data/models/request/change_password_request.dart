class ChangePasswordRequest {
  final String password;
  final String newPassword;

  const ChangePasswordRequest({
    required this.password,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'password': password,
    'newPassword': newPassword,
  };
}
