import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/address_response/adress_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/cash_checkout_response.dart';

abstract interface class CheckoutRemoteDataSourceContract {
  Future<BaseResponse<AddressResponse>> addresses();
  Future<BaseResponse<CashCheckoutResponse>> cashCheckout(CheckoutRequest request);
  Future<BaseResponse<CardCheckoutResponse>> cardCheckout(
    String cartId,
    CheckoutRequest request,
  );
   int getDeliveryDays();
}
