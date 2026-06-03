import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/checkout_session_model.dart';
class CardCheckoutResponse {
  final String message;
  final CheckoutSessionModel session;

  const CardCheckoutResponse({
    required this.message,
    required this.session,
  });

  factory CardCheckoutResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CardCheckoutResponse(
      message: json['message'] ?? '',
      session: CheckoutSessionModel.fromJson(
        json['session'],
      ),
    );
  }
}