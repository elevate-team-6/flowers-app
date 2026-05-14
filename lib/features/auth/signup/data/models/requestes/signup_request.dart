import 'package:equatable/equatable.dart';

import '../../../../../../core/utils/app_params.dart';

class SignupRequest extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String rePassword;
  final String phone;
  final String gender;

  const SignupRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.phone,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
    ApiParameters.firstName: firstName,
    ApiParameters.lastName: lastName,
    ApiParameters.email: email,
    ApiParameters.password: password,
    ApiParameters.rePassword: rePassword,
    ApiParameters.phone: phone,
    ApiParameters.gender: gender,
  };

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    rePassword,
    phone,
    gender,
  ];
}
