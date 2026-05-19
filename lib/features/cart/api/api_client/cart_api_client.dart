import 'package:dio/dio.dart';
import 'package:flowers_app/core/utils/app_end_points.dart';
import 'package:flowers_app/features/cart/data/models/request/add_to_cart_request.dart';
import 'package:flowers_app/features/cart/data/models/request/update_quantity_request.dart';
import 'package:flowers_app/features/cart/data/models/response/cart_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'cart_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class CartApiClient {
  @factoryMethod
  factory CartApiClient(Dio dio) = _CartApiClient;

  @GET(AppEndPoints.cart)
  Future<CartResponse> getCart();

  @POST(AppEndPoints.cart)
  Future<CartResponse> addToCart(@Body() AddToCartRequest request);

  @PUT('${AppEndPoints.cart}/{productId}')
  Future<CartResponse> updateQuantity(
    @Path('productId') String productId,
    @Body() UpdateQuantityRequest request,
  );

  @DELETE('${AppEndPoints.cart}/{productId}')
  Future<CartResponse> removeItem(@Path('productId') String productId);
}
