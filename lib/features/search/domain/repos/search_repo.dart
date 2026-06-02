import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';

abstract interface class SearchRepo {
  Future<BaseResponse<List<ProductEntity>>> searchProducts(
    GetProductsParams params,
  );
}
