import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/entities/product_entity.dart';

abstract interface class ProductDetailsRepoContract {
  Future<BaseResponse<ProductEntity>> getProductDetiles({required String productId});
}
