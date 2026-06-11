import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';

abstract interface class SearchRemoteDataSource {
  Future<BaseResponse<GetAllProductsResponse>> searchProducts(
    GetProductsParams params,
  );
}
