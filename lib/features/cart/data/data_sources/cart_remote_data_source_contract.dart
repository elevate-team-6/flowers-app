import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/cart/data/models/response/cart_response.dart';

abstract interface class CartRemoteDataSourceContract {
  Future<BaseResponse<CartResponse>> getCart();
  Future<BaseResponse<CartResponse>> addToCart(String productId, int quantity);
  Future<BaseResponse<CartResponse>> updateQuantity(
    String productId,
    int quantity,
  );
  Future<BaseResponse<CartResponse>> removeItem(String productId);
  Future<BaseResponse<CartResponse>> clearCart();
}
