import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  @JsonKey(name: "_id")
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? role;
  final List<dynamic>? wishlist;
  final List<dynamic>? addresses;
  final String? createdAt;
  final bool? resetCodeVerified;

  const UserProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.wishlist,
    this.addresses,
    this.createdAt,
    this.resetCodeVerified,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  UserProfileEntity toEntity() => UserProfileEntity(
    id: id,
    firstName: firstName,
    lastName: lastName,
    gender: gender,
    phone: phone,
    email: email,
    photo: photo,
    wishlist: wishlist,
    addresses: addresses,
  );
}
