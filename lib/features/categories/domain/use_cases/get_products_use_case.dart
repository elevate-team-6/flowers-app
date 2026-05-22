import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/data/repositories/categories_repo_contract.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/entities/product_entity.dart';

@injectable
class GetProductsUseCase {
  final CategoriesRepoContract _categoriesRepo;

  const GetProductsUseCase(this._categoriesRepo);

  Future<BaseResponse<List<ProductEntity>>> call({GetProductsParams? params}) {
    return _categoriesRepo.getProducts(params ?? const GetProductsParams());
  }
}
