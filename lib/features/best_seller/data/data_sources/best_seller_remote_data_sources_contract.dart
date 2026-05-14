import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/best_seller/data/models/best_seller_products_response/best_seller_products_response.dart';

abstract interface class BestSellerRemoteDataSourcesContract {
  Future<BaseResponse<BestSellerProductsResponse>> bestSeller();
}
