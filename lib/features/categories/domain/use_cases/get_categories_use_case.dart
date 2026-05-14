import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/categories/data/repositories/categories_repo_contract.dart';
import 'package:flowers_app/features/categories/domain/entities/category_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesUseCase {
  final CategoriesRepoContract _categoriesRepo;

  const GetCategoriesUseCase(this._categoriesRepo);

  Future<BaseResponse<CategoriesEntity>> call() {
    return _categoriesRepo.getCategories();
  }
}
