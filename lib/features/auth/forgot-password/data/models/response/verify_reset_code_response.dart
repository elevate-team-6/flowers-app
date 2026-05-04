import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/auth/forgot-password/domain/entites/forget_password_entity.dart';

class VerifyResetCodeResponse extends Equatable {
  final String? status;
  final String? message;

  const VerifyResetCodeResponse({this.status, this.message});

  factory VerifyResetCodeResponse.fromJson(Map<String, dynamic> json) {
    return VerifyResetCodeResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'message': message};

  ForgotPasswordEntity toEntity() =>
      ForgotPasswordEntity(status: status, message: message);

  @override
  List<Object?> get props => [status, message];
}
