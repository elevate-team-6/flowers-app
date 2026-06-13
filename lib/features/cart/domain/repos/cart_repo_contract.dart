import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';

abstract interface class CartRepoContract {
  Future<BaseResponse<CartEntity>> getCart();
  Future<BaseResponse<String>> clearCart();
  Future<BaseResponse<CartEntity>> addToCart(String productId, int quantity);
  Future<BaseResponse<CartEntity>> updateQuantity(
    String productId,
    int quantity,
  );
  Future<BaseResponse<CartEntity>> removeItem(String productId);
}
