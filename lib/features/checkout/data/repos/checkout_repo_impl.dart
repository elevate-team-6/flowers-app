import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/checkout/data/data_sources/checkout_remote_data_source_contract.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/address_response/adress_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/cash_checkout_response.dart';
import 'package:flowers_app/features/checkout/domain/entities/address_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/card_entity.dart';
import 'package:flowers_app/features/checkout/domain/entities/order_entity.dart';
import 'package:flowers_app/features/checkout/domain/repos/checkout_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CheckoutRepoContract)
class CheckoutRepoImpl implements CheckoutRepoContract {
  final CheckoutRemoteDataSourceContract _checkoutRemoteDataSource;
  const CheckoutRepoImpl(this._checkoutRemoteDataSource);
  @override
  Future<BaseResponse<List<AddressEntity>>> addresses() async {
    final response = await _checkoutRemoteDataSource.addresses();
    switch (response) {
      case SuccessBaseResponse<AddressResponse>():
        return SuccessBaseResponse(
          response.data.addresses.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<AddressResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<CardEntity>> cardCheckout(
    String cartId,
    CheckoutRequest request,
  ) async {
    final response = await _checkoutRemoteDataSource.cardCheckout(
      cartId,
      request,
    );
    switch (response) {
      case SuccessBaseResponse<CardCheckoutResponse>():

        return SuccessBaseResponse(response.data.session.toDomain());
      case ErrorBaseResponse<CardCheckoutResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }

  @override
  Future<BaseResponse<OrderEntity>> cashCheckout(
    CheckoutRequest request,
  ) async {
    final response = await _checkoutRemoteDataSource.cashCheckout(request);
    switch (response) {
      case SuccessBaseResponse<CashCheckoutResponse>():
        return SuccessBaseResponse(response.data.order.toDomain());
      case ErrorBaseResponse<CashCheckoutResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }
}
