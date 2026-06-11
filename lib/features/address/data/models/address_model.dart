import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel extends Equatable {
  @JsonKey(name: '_id', includeToJson: false)
  final String? id;
  @JsonKey(name: 'street')
  final String? street;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'city')
  final String? city;
  @JsonKey(name: 'lat')
  final String? lat;
  @JsonKey(name: 'long')
  final String? long;
  @JsonKey(name: 'username')
  final String? username;

  const AddressModel({
    this.id,
    this.street,
    this.phone,
    this.city,
    this.lat,
    this.long,
    this.username,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      username: entity.recipientName,
      phone: entity.phoneNumber,
      street: "${entity.area}${AppConstants.addressDelimiter}${entity.street}",
      city: entity.city,
      lat: entity.latitude,
      long: entity.longitude,
    );
  }

  AddressEntity toEntity() {
    String area = "";
    String streetName = street ?? "";

    if (streetName.contains(AppConstants.addressDelimiter)) {
      final parts = streetName.split(AppConstants.addressDelimiter);
      area = parts[0];
      streetName = parts.sublist(1).join(AppConstants.addressDelimiter);
    }

    return AddressEntity(
      id: id,
      recipientName: username ?? '',
      phoneNumber: phone ?? '',
      street: streetName,
      area: area,
      city: city ?? '',
      latitude: lat ?? '',
      longitude: long ?? '',
      isDefault: false,
    );
  }

  @override
  List<Object?> get props => [id, street, phone, city, lat, long, username];
}
