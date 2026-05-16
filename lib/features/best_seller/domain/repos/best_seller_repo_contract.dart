import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';

abstract interface class BestSellerRepoContract {
  Future<BaseResponse<List<ProductEntity>>> bestSeller();
}
