class ChangePasswordResponse {
  final String? message;
  final String? token;

  const ChangePasswordResponse({this.message, this.token});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      ChangePasswordResponse(
        message: json['message'] as String?,
        token: json['token'] as String?,
      );
}
