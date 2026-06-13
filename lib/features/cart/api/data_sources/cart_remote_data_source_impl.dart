import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/cart/api/api_client/cart_api_client.dart';
import 'package:flowers_app/features/cart/data/data_sources/cart_remote_data_source_contract.dart';
import 'package:flowers_app/features/cart/data/models/request/add_to_cart_request.dart';
import 'package:flowers_app/features/cart/data/models/request/update_quantity_request.dart';
import 'package:flowers_app/features/cart/data/models/response/cart_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRemoteDataSourceContract)
class CartRemoteDataSourceImpl implements CartRemoteDataSourceContract {
  final CartApiClient _apiClient;
  const CartRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<CartResponse>> getCart() =>
      ErrorHandler.handleApiCall(() => _apiClient.getCart());

  @override
  Future<BaseResponse<CartResponse>> addToCart(
    String productId,
    int quantity,
  ) => ErrorHandler.handleApiCall(
    () => _apiClient.addToCart(
      AddToCartRequest(product: productId, quantity: quantity),
    ),
  );

  @override
  Future<BaseResponse<CartResponse>> updateQuantity(
    String productId,
    int quantity,
  ) => ErrorHandler.handleApiCall(
    () => _apiClient.updateQuantity(
      productId,
      UpdateQuantityRequest(quantity: quantity),
    ),
  );

  @override
  Future<BaseResponse<CartResponse>> removeItem(String productId) =>
      ErrorHandler.handleApiCall(() => _apiClient.removeItem(productId));

  @override
  Future<BaseResponse<String>> clearCart() {
    return ErrorHandler.handleApiCall(() => _apiClient.clearCart());
  }
}
