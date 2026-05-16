import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequestedEvent  extends LoginEvent {
  final String email;
  final String password;
    final bool isRememberMe;


  const LoginRequestedEvent ({
    required this.email,
    required this.password,
    required this.isRememberMe,
  });

  @override
  List<Object?> get props => [email, password, isRememberMe];
}
class ToggleRememberMeEvent  extends LoginEvent {
  final bool value;

  const ToggleRememberMeEvent (this.value);
}
class TogglePasswordVisibilityEvent  extends LoginEvent {
  const TogglePasswordVisibilityEvent ();
}