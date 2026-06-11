import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_requests/checkout_request.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/card_response/card_checkout_response.dart';
import 'package:flowers_app/features/checkout/data/models/checkout_responses/cash_response/cash_checkout_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'checkout_api_client.g.dart';

@injectable
@RestApi()
abstract class CheckoutApiClient {
  @factoryMethod
  factory CheckoutApiClient(Dio dio) = _CheckoutApiClient;
  @POST(AppEndPoints.cashCheckout)
  Future<CashCheckoutResponse> cashCheckout(@Body() CheckoutRequest request);
  @POST(AppEndPoints.cardCheckout)
  Future<CardCheckoutResponse> cardCheckout(
    @Query(AppConstants.checkoutUrlQuery) String url,
    @Body() CheckoutRequest request,
  );
}
