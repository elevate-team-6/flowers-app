import 'package:flowers_app/config/cache/hive_helper.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/notifications/data/data_sources/notifications_local_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationsLocalDataSourceContract)
class NotificationsLocalDataSourceImpl
    implements NotificationsLocalDataSourceContract {
  final HiveHelper _hiveHelper;

  const NotificationsLocalDataSourceImpl(this._hiveHelper);

  @override
  Future<void> saveLastOpenedTime(DateTime time) {
    return _hiveHelper.cacheData<DateTime>(
      boxName: AppConstants.notificationsBox,
      key: AppConstants.lastOpenedNotificationsTimeKey,
      value: time,
    );
  }

  @override
  Future<DateTime?> getLastOpenedTime() {
    return _hiveHelper.getData<DateTime>(
      boxName: AppConstants.notificationsBox,
      key: AppConstants.lastOpenedNotificationsTimeKey,
    );
  }
}
