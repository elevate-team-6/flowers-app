import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/config/services/remote_config_service.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/checkout/api/checkout_api_client/checkout_api_client.dart';
import 'package:flowers_app/features/checkout/data/data_sources/checkout_remote_data_source_contract.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/address_response/adress_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/cash_checkout_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CheckoutRemoteDataSourceContract)
class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSourceContract {
  final CheckoutApiClient _apiClient;
  final RemoteConfigService _remoteConfig;
  const CheckoutRemoteDataSourceImpl(this._apiClient,this._remoteConfig);

  @override
  Future<BaseResponse<AddressResponse>> addresses() {
    return ErrorHandler.handleApiCall(() {
      return _apiClient.addresses();
    });
  }

  @override
  Future<BaseResponse<CardCheckoutResponse>> cardCheckout(
    String cartId,
    CheckoutRequest request,
  ) {
    return ErrorHandler.handleApiCall(() {
      return _apiClient.cardCheckout(
        '${AppConstants.checkoutRedirectUrl}/$cartId',
        request,
      );
    });
  }

  @override
  Future<BaseResponse<CashCheckoutResponse>> cashCheckout(
    CheckoutRequest request,
  ) {
    return ErrorHandler.handleApiCall(() {
      return _apiClient.cashCheckout(request);
    });
  }

  @override
  int getDeliveryDays() {
    return _remoteConfig.deliveryDays;
  }
}
