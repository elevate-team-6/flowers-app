import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'address_model.dart';

part 'address_response.g.dart';

@JsonSerializable()
class AddressResponse extends Equatable {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(readValue: _readAddressData)
  final List<AddressModel>? addresses;

  const AddressResponse({this.message, this.addresses});

  static Object? _readAddressData(Map json, String key) {
    return json['addresses'] ?? json['address'];
  }

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddressResponseToJson(this);

  @override
  List<Object?> get props => [message, addresses];
}
