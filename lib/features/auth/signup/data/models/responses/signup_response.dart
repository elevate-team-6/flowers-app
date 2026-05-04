import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/utils/app_params.dart';
import 'package:flowers_app/features/auth/signup/data/models/responses/user_model.dart';

class SignupResponse extends Equatable {
  final String? message;
  final UserModel? user;
  final String? token;

  const SignupResponse({this.message, this.user, this.token});

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
    message: json[AppParams.message] as String?,
    token: json[AppParams.token] as String?,
    user: json[AppParams.user] != null
        ? UserModel.fromJson(json[AppParams.user] as Map<String, dynamic>)
        : null,
  );

  @override
  List<Object?> get props => [message, user, token];
}
