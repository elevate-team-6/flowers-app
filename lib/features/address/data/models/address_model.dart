import 'package:equatable/equatable.dart';
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

  @override
  List<Object?> get props => [id, street, phone, city, lat, long, username];
}
