import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/notifications/data/data_sources/notifications_local_data_source_contract.dart';
import 'package:flowers_app/features/notifications/data/data_sources/notifications_remote_data_source_contract.dart';
import 'package:flowers_app/features/notifications/data/models/notification_model.dart';
import 'package:flowers_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:flowers_app/features/notifications/domain/entities/notifications_result_entity.dart';
import 'package:flowers_app/features/notifications/domain/repos/notifications_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationsRepoContract)
class NotificationsRepoImpl implements NotificationsRepoContract {
  final NotificationsRemoteDataSourceContract _remoteDataSource;
  final NotificationsLocalDataSourceContract _localDataSource;
  final SecureCacheHelper _cacheHelper;

  const NotificationsRepoImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._cacheHelper,
  );

  @override
  Future<BaseResponse<NotificationsResultEntity>> getNotifications() async {
    final userId = await _cacheHelper.readData(key: AppKeys.userIdKey);

    if (userId == null) {
      return ErrorBaseResponse(AppStrings.userNotFound.tr());
    }

    final result = await _remoteDataSource.getNotifications(userId);

    return switch (result) {
      SuccessBaseResponse<List<NotificationModel>>(:final data) =>
        SuccessBaseResponse<NotificationsResultEntity>(
          await _buildResult(data.map((model) => model.toEntity()).toList()),
        ),
      ErrorBaseResponse<List<NotificationModel>>(:final errorMessage) =>
        ErrorBaseResponse<NotificationsResultEntity>(errorMessage),
    };
  }

  @override
  Future<BaseResponse<void>> clearNotifications() async {
    final userId = await _cacheHelper.readData(key: AppKeys.userIdKey);

    if (userId == null) {
      return ErrorBaseResponse(AppStrings.userNotFound.tr());
    }

    return await _remoteDataSource.clearNotifications(userId);
  }

  @override
  Future<void> markNotificationsAsOpened() {
    return _localDataSource.saveLastOpenedTime(DateTime.now());
  }

  Future<NotificationsResultEntity> _buildResult(
    List<NotificationEntity> notifications,
  ) async {
    final sorted = _sortByNewest(notifications);
    final lastOpenedTime = await _localDataSource.getLastOpenedTime();

    final unreadCount = lastOpenedTime == null
        ? sorted.length
        : sorted.where((n) => n.sentTime.isAfter(lastOpenedTime)).length;

    return NotificationsResultEntity(
      notifications: sorted,
      unreadCount: unreadCount,
    );
  }

  List<NotificationEntity> _sortByNewest(
    List<NotificationEntity> notifications,
  ) {
    final sorted = List<NotificationEntity>.from(notifications)
      ..sort((a, b) => b.sentTime.compareTo(a.sentTime));
    return sorted;
  }
}
