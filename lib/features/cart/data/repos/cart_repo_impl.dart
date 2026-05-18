import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/cart/data/data_sources/cart_remote_data_source_contract.dart';
import 'package:flowers_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flowers_app/features/cart/domain/repos/cart_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRepoContract)
class CartRepoImpl implements CartRepoContract {
  final CartRemoteDataSourceContract _dataSource;
  const CartRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<CartEntity>> getCart() async {
    final result = await _dataSource.getCart();
    switch (result) {
      case SuccessBaseResponse():
        return SuccessBaseResponse(result.data.toEntity());
      case ErrorBaseResponse():
        return ErrorBaseResponse(result.errorMessage);
    }
  }

  @override
  Future<BaseResponse<CartEntity>> addToCart(
    String productId,
    int quantity,
  ) async {
    final result = await _dataSource.addToCart(productId, quantity);
    switch (result) {
      case SuccessBaseResponse():
        return SuccessBaseResponse(result.data.toEntity());
      case ErrorBaseResponse():
        return ErrorBaseResponse(result.errorMessage);
    }
  }

  @override
  Future<BaseResponse<CartEntity>> updateQuantity(
    String productId,
    int quantity,
  ) async {
    final result = await _dataSource.updateQuantity(productId, quantity);
    switch (result) {
      case SuccessBaseResponse():
        return SuccessBaseResponse(result.data.toEntity());
      case ErrorBaseResponse():
        return ErrorBaseResponse(result.errorMessage);
    }
  }

  @override
  Future<BaseResponse<CartEntity>> removeItem(String productId) async {
    final result = await _dataSource.removeItem(productId);
    switch (result) {
      case SuccessBaseResponse():
        return SuccessBaseResponse(result.data.toEntity());
      case ErrorBaseResponse():
        return ErrorBaseResponse(result.errorMessage);
    }
  }

  @override
  Future<BaseResponse<CartEntity>> clearCart() async {
    final result = await _dataSource.clearCart();
    switch (result) {
      case SuccessBaseResponse():
        return SuccessBaseResponse(result.data.toEntity());
      case ErrorBaseResponse():
        return ErrorBaseResponse(result.errorMessage);
    }
  }
}
