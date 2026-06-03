import 'package:flowers_app/features/checkout/data/models/checkout_responses/address_response/address_model.dart';

class AddressResponse {
  final String message;
  final List<AddressModel> addresses;

  const AddressResponse({
    required this.message,
    required this.addresses,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      message: json['message'] ?? '',
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((e) => AddressModel.fromJson(e))
          .toList(),
    );
  }
}