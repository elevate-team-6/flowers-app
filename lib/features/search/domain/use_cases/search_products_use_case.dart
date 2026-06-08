import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/search/domain/repos/search_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchProductsUseCase {
  final SearchRepo _repo;

  SearchProductsUseCase(this._repo);

  Future<BaseResponse<List<ProductEntity>>> call(GetProductsParams params) {
    return _repo.searchProducts(params);
  }
}
