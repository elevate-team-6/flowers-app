import 'package:equatable/equatable.dart';

class CardEntity extends Equatable {
  final String id;
  final String paymentStatus;
  final String status;
  final String url;
  final String successUrl;
  final String cancelUrl;

  const CardEntity({
    required this.id,
    required this.paymentStatus,
    required this.status,
    required this.url,
    required this.successUrl,
    required this.cancelUrl,
  });

  @override
  List<Object?> get props => [
    id,
    paymentStatus,
    status,
    url,
    successUrl,
    cancelUrl,
  ];
}
