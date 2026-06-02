import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:flowers_app/features/search/api/api_client/search_api_client.dart';
import 'package:flowers_app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRemoteDataSource)
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final SearchApiClient _apiClient;

  SearchRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<GetAllProductsResponse>> searchProducts(
    GetProductsParams params,
  ) {
    return ErrorHandler.handleApiCall(
      () => _apiClient.searchProducts(queries: params.toJson()),
    );
  }
}
