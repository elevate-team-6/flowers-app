import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginClicked extends LoginEvent {
  final String email;
  final String password;

  const LoginClicked({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class TogglePasswordVisibility extends LoginEvent {
  const TogglePasswordVisibility();
}