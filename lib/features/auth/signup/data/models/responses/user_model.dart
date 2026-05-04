import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/utils/app_params.dart';
import 'package:flowers_app/features/auth/signup/domain/entities/user_entity.dart';

class UserModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String phone;
  final String photo;
  final String role;
  final String createdAt;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phone,
    required this.photo,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json[AppParams.id] as String? ?? '',
    firstName: json[AppParams.firstName] as String? ?? '',
    lastName: json[AppParams.lastName] as String? ?? '',
    email: json[AppParams.email] as String? ?? '',
    gender: json[AppParams.gender] as String? ?? '',
    phone: json[AppParams.phone] as String? ?? '',
    photo: json[AppParams.photo] as String? ?? '',
    role: json[AppParams.role] as String? ?? '',
    createdAt: json[AppParams.createdAt] as String? ?? '',
  );

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    gender,
    phone,
    photo,
    role,
    createdAt,
  ];

  UserEntity toEntity() => UserEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    gender: gender,
    phone: phone,
    photo: photo,
    role: role,
    createdAt: createdAt,
  );
}
