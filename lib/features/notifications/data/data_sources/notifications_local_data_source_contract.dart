abstract interface class NotificationsLocalDataSourceContract {
  Future<void> saveLastOpenedTime(DateTime time);
  Future<DateTime?> getLastOpenedTime();
}
