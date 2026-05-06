import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginClicked extends LoginEvent {
  final String email;
  final String password;
    final bool isRememberMe;


  const LoginClicked({
    required this.email,
    required this.password,
    required this.isRememberMe,
  });

  @override
  List<Object?> get props => [email, password, isRememberMe];
}

class TogglePasswordVisibility extends LoginEvent {
  const TogglePasswordVisibility();
}