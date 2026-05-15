import 'package:flowers_app/features/auth/login/data/models/login_response/user_dto.dart';

class LoginResponse {
  String? message;
  UserDto? user;
  String? token;

  LoginResponse({this.message, this.user, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] as String?,
      token: json['token'] as String?,
      user: json['user'] != null ? UserDto.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'token': token, 'user': user?.toJson()};
  }
}
