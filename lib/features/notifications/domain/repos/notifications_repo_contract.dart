import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/notifications/domain/entities/notifications_result_entity.dart';

abstract interface class NotificationsRepoContract {
  Future<BaseResponse<NotificationsResultEntity>> getNotifications();
  Future<void> markNotificationsAsOpened();
}
