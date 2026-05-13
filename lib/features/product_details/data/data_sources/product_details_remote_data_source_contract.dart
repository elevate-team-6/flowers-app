import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/product_details/data/models/product_details_response/product_details_response.dart';

abstract interface class ProductDetailsRemoteDataSourceContract {
  Future<BaseResponse<ProductDetailsResponse>> getProductDetiles({
    required String productId,
  });
}
