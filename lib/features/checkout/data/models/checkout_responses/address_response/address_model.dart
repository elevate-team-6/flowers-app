import 'package:flowers_app/features/checkout/domain/entities/address_entity.dart';

class AddressModel {
  final String id;
  final String street;
  final String phone;
  final String city;
  final String lat;
  final String long;
  final String username;

  const AddressModel({
    required this.id,
    required this.street,
    required this.phone,
    required this.city,
    required this.lat,
    required this.long,
    required this.username,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] ?? '',
      street: json['street'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      lat: json['lat'] ?? '',
      long: json['long'] ?? '',
      username: json['username'] ?? '',
    );
  }

  AddressEntity toDomain() {
    return AddressEntity(
      id: id,
      street: street,
      phone: phone,
      city: city,
      lat: lat,
      long: long,
      username: username,
    );
  }
}