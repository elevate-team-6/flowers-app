// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
    final String? id;
    final String? token;
    final String? firstName;
    final String? lastName;
    final String? email;
    final String? gender;
    final String? phone;
    final String? photo;
    final String? role;
    final String? createdAt;
  const LoginEntity({
    required this.id,
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phone,
    required this.photo,
    required this.role,
    required this.createdAt,
  });
  @override
  List<Object?> get props => [id,firstName ,lastName, email ,gender,phone,photo,role,createdAt];
}
