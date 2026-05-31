import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String? id;
  final String? photo;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? gender;
  final List<dynamic>? wishlist;
  final List<dynamic>? addresses;

  const UserProfileEntity({
    this.id,
    this.photo,
    this.firstName,
    this.lastName,
    this.email,
    this.wishlist,
    this.addresses,
    this.phone,
    this.gender,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    photo,
    phone,
    gender,
    wishlist,
    addresses,
  ];
}
