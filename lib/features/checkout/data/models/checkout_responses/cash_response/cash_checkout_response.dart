import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/order_model.dart';
import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';

class CashCheckoutResponse {
  final String? message;
  final OrderModel? order;

  const CashCheckoutResponse({ this.message,  this.order});

  factory CashCheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CashCheckoutResponse(
      message: json['message'] ?? '',
      order: OrderModel.fromJson(json['order']),
    );
  }

  OrderEntity toDomain() {
    return order!.toDomain();
  }
}
