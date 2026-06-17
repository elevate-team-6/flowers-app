import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_categories_response.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';

abstract interface class CategoriesRemoteDataSourceContract {
  Future<BaseResponse<GetAllCategoriesResponse>> getCategories();
  Future<BaseResponse<GetAllProductsResponse>> getProducts(
    GetProductsParams params,
  );
}
