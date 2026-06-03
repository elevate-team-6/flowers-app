import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/domain/entities/address_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';

abstract interface class CheckoutRepoContract {
  Future<BaseResponse<List<AddressEntity>>> addresses();
  Future<BaseResponse<OrderEntity>> cashCheckout(CheckoutRequest request);
  Future<BaseResponse<CardEntity>> cardCheckout(
    String cartId,
    CheckoutRequest request,
  );
}
