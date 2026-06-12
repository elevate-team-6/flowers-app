import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';

sealed class CheckoutEvent {
  const CheckoutEvent();
}

class SelectAddressEvent extends CheckoutEvent {
  final AddressEntity address;

  const SelectAddressEvent(this.address);
}

class SelectPaymentMethodEvent extends CheckoutEvent {
  final String paymentMethod;

  const SelectPaymentMethodEvent(this.paymentMethod);
}

class CashCheckoutEvent extends CheckoutEvent {
  final CheckoutRequest request;

  const CashCheckoutEvent(this.request);
}

class CardCheckoutEvent extends CheckoutEvent {
  final String cartId;
  final CheckoutRequest request;

  const CardCheckoutEvent({required this.cartId, required this.request});
}
class ToggleGiftEvent extends CheckoutEvent {
  final bool isGift;

  const ToggleGiftEvent(this.isGift);
}
class LoadDeliveryDaysEvent extends CheckoutEvent {}
