import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/auth/login/domain/entities/login_entity.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final LoginEntity? user;
  final bool isPasswordObscure;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.isPasswordObscure = true,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    LoginEntity? user,
    bool? isPasswordObscure,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
      isPasswordObscure:
          isPasswordObscure ?? this.isPasswordObscure,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        user,
        isPasswordObscure,
      ];
}