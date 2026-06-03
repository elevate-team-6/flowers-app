import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';

class CheckoutSessionModel {
  final String id;
  final String paymentStatus;
  final String status;
  final String url;

  const CheckoutSessionModel({
    required this.id,
    required this.paymentStatus,
    required this.status,
    required this.url,
  });

  factory CheckoutSessionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CheckoutSessionModel(
      id: json['id'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      status: json['status'] ?? '',
      url: json['url'] ?? '',
    );
  }

  CardEntity toDomain() {
    return CardEntity(
      id: id,
      paymentStatus: paymentStatus,
      status: status,
      url: url,
    );
  }
}