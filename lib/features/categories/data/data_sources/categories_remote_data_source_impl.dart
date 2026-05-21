import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/categories/api/api_client/categories_api_client.dart';
import 'package:flowers_app/features/categories/api/data_sources/categories_remote_data_source_contract.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_categories_response.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoriesRemoteDataSourceContract)
class CategoriesRemoteDataSourceImpl
    implements CategoriesRemoteDataSourceContract {
  final CategoriesApiClient _categoriesApiClient;

  const CategoriesRemoteDataSourceImpl(this._categoriesApiClient);

  @override
  Future<BaseResponse<GetAllCategoriesResponse>> getCategories() {
    return ErrorHandler.handleApiCall(() {
      return _categoriesApiClient.getCategories();
    });
  }

  @override
  Future<BaseResponse<GetAllProductsResponse>> getProducts(
      GetProductsParams params) {
    return ErrorHandler.handleApiCall(() {
      return _categoriesApiClient.getProducts(queries: params.toJson());
    });
  }
}
