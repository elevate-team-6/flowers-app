import 'package:flowers_app/features/profile/edit_profile/domain/entities/user_edit_profile_entity.dart';

class UserModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phone,
    required this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      gender: json['gender'],
      phone: json['phone'],
      photo: json['photo'],
    );
  }
  UserEditProfileEntity toEntity() => UserEditProfileEntity(
    lastName: lastName??'',
    firstName: firstName??'',
    gender: gender??'',
    phone: phone??'',
    photo: photo??'',
  );
}
