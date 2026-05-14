import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/product_details/domain/entities/product_details_entity.dart';

abstract interface class ProductDetailsRepoContract {
  Future<BaseResponse<ProductDetailsEntity>> getProductDetiles({
    required String productId,
  });
}
