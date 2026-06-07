import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_products_response.dart';
import 'package:flowers_app/features/search/data/data_sources/search_local_data_source.dart';
import 'package:flowers_app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:flowers_app/features/search/domain/repos/search_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRepo)
class SearchRepoImpl implements SearchRepo {
  final SearchRemoteDataSource _remoteDataSource;
  final SearchLocalDataSource _localDataSource;

  SearchRepoImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<BaseResponse<List<ProductEntity>>> searchProducts(
    GetProductsParams params,
  ) async {
    final response = await _remoteDataSource.searchProducts(params);
    switch (response) {
      case SuccessBaseResponse<GetAllProductsResponse>():
        final products = response.data.products ?? [];
        return SuccessBaseResponse(products.map((e) => e.toEntity()).toList());
      case ErrorBaseResponse<GetAllProductsResponse>():
        return ErrorBaseResponse(response.errorMessage);
    }
  }

  @override
  Future<List<String>> getSearchHistory() {
    return _localDataSource.getSearchHistory();
  }

  @override
  Future<void> saveSearchHistory(List<String> history) {
    return _localDataSource.saveSearchHistory(history);
  }

  @override
  Future<void> clearSearchHistory() {
    return _localDataSource.clearSearchHistory();
  }
}
