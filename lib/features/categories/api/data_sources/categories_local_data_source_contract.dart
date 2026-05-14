import 'package:flowers_app/features/categories/data/models/response/get_all_categories_response.dart';

abstract interface class CategoriesLocalDataSourceContract {
  Future<void> cacheCategories(GetAllCategoriesResponse categories);
  Future<GetAllCategoriesResponse?> getCachedCategories();
}
