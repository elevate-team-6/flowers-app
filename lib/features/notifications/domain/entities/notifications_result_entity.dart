import 'package:equatable/equatable.dart';
import 'package:flowers_app/features/notifications/domain/entities/notification_entity.dart';

class NotificationsResultEntity extends Equatable {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationsResultEntity({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}
