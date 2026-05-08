import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/entites/forget_password_entity.dart';

class ForgotPasswordResponse extends Equatable {
  final String? message;
  final String? info;
  final String? statusMsg;

  const ForgotPasswordResponse({this.message, this.info, this.statusMsg});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'] as String?,
      info: json['info'] as String?,
      statusMsg: json['statusMsg'] as String?,
    );
  }

  ForgotPasswordEntity toEntity() =>
      ForgotPasswordEntity(message: message, info: info, statusMsg: statusMsg);

  @override
  List<Object?> get props => [message, info, statusMsg];
}
