import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String? id;
  final String recipientName;
  final String phoneNumber;
  final String street;
  final String city;
  final String area;
  final String latitude;
  final String longitude;
  final bool isDefault;

  const AddressEntity({
    this.id,
    required this.recipientName,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.area,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [
    id,
    recipientName,
    phoneNumber,
    street,
    city,
    area,
    latitude,
    longitude,
    isDefault,
  ];
}
