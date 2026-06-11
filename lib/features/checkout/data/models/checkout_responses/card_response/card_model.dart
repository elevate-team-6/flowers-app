import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';

class CardModel {
  final String? id;
  final String? paymentStatus;
  final String? status;
  final String? url;
  final String? successUrl;
  final String? cancelUrl;

  const CardModel({
    this.id,
    this.paymentStatus,
    this.status,
    this.url,
    this.successUrl,
    this.cancelUrl,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      status: json['status'] ?? '',
      url: json['url'] ?? '',
    );
  }

  CardEntity toDomain() {
    return CardEntity(
      id: id ?? '',
      paymentStatus: paymentStatus ?? '',
      status: status ?? '',
      url: url ?? '',
      successUrl: successUrl ?? '',
      cancelUrl: cancelUrl ?? '',
    );
  }
}
