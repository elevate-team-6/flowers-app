import 'package:json_annotation/json_annotation.dart';
part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "firstName")
  String? firstName;
  @JsonKey(name: "lastName")
  String? lastName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "gender")
  String? gender;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "photo")
  String? photo;
  @JsonKey(name: "role")
  String? role;
  @JsonKey(name: "createdAt")
  String? createdAt;

  UserDto({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
  });
Map<String, dynamic> toJson() {
  return {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'gender': gender,
    'phone': phone,
    'photo': photo,
  };
}
  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  
}
