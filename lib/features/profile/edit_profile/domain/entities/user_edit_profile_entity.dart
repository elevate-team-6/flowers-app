import 'package:equatable/equatable.dart';

class UserEditProfileEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? phone;
  final String? image;

  const UserEditProfileEntity({
    this.firstName,
    this.lastName,
    this.gender,
    this.phone,
    this.image,
  });

  @override
  List<Object?> get props => [firstName, lastName, gender, image, phone];
}
