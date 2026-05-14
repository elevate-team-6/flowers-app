import 'dart:convert';

import 'package:flowers_app/config/cache/hive_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/categories/api/data_sources/categories_local_data_source_contract.dart';
import 'package:flowers_app/features/categories/data/models/response/get_all_categories_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoriesLocalDataSourceContract)
class CategoriesLocalDataSourceImpl
    implements CategoriesLocalDataSourceContract {
  final HiveHelper _hiveHelper;

  const CategoriesLocalDataSourceImpl(this._hiveHelper);

  @override
  Future<void> cacheCategories(GetAllCategoriesResponse categories) async {
    await _hiveHelper.cacheData<String>(
      boxName: AppKeys.categoriesBox,
      key: AppKeys.categoriesKey,
      value: jsonEncode(categories.toJson()),
    );
  }

  @override
  Future<GetAllCategoriesResponse?> getCachedCategories() async {
    final jsonString = await _hiveHelper.getData<String>(
      boxName: AppKeys.categoriesBox,
      key: AppKeys.categoriesKey,
    );
    if (jsonString != null) {
      return GetAllCategoriesResponse.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    }
    return null;
  }
}
