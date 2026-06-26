import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/notifications/data/models/notification_model.dart';

abstract interface class NotificationsRemoteDataSourceContract {
  Future<BaseResponse<List<NotificationModel>>> getNotifications(String userId);
}
