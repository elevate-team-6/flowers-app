import 'package:flowers_app/config/cache/hive_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/search/data/data_sources/search_local_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchLocalDataSource)
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final HiveHelper _hiveHelper;

  SearchLocalDataSourceImpl(this._hiveHelper);

  @override
  Future<List<String>> getSearchHistory() async {
    final history = await _hiveHelper.getData<List<dynamic>>(
      boxName: AppKeys.searchHistoryBox,
      key: AppKeys.searchHistoryKey,
    );
    return history?.cast<String>() ?? [];
  }

  @override
  Future<void> saveSearchHistory(List<String> history) async {
    await _hiveHelper.cacheData(
      boxName: AppKeys.searchHistoryBox,
      key: AppKeys.searchHistoryKey,
      value: history,
    );
  }

  @override
  Future<void> clearSearchHistory() async {
    await _hiveHelper.clearBox(boxName: AppKeys.searchHistoryBox);
  }
}
