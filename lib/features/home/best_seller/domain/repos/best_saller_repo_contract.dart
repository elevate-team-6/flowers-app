import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/home/best_seller/domain/entities/product_entity.dart';

abstract interface class BestSallerRepoContract {
  Future<BaseResponse<List<ProductEntity>>> bestSeller();
}
