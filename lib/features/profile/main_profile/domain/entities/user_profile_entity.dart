import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? photo;
  final List<dynamic>? wishlist;
  final List<dynamic>? addresses;

  const UserProfileEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.photo,
    this.wishlist,
    this.addresses,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    photo,
    wishlist,
    addresses,
  ];
}
