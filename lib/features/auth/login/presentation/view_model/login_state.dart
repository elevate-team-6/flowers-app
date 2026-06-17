import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/auth/login/domain/entities/user_entity.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? user;
  final bool isPasswordObscure;
  final bool isRememberMe;

  const LoginState({
    this.isLoading = false,
    this.isRememberMe = false,
    this.errorMessage,
    this.user,
    this.isPasswordObscure = true,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isRememberMe,
    String? errorMessage,
    UserEntity? user,
    bool? isPasswordObscure,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isRememberMe: isRememberMe ?? this.isRememberMe,
      errorMessage: errorMessage,
      user: user ?? this.user,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    user,
    isPasswordObscure,
    isRememberMe,
  ];
}
