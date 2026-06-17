import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';

sealed class SignupEvents extends Equatable {
  const SignupEvents();
}

class SignupEvent extends SignupEvents {
  final SignupRequest request;
  const SignupEvent(this.request);

  @override
  List<Object?> get props => [request];
}
