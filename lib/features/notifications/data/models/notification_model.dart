import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends Equatable {
  final String title;
  final String body;
  final DateTime sentTime;
  final Map<String, dynamic>? data;

  const NotificationModel({
    required this.title,
    required this.body,
    required this.sentTime,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json[AppConstants.notificationTitleField] as String? ?? '',
      body: json[AppConstants.notificationBodyField] as String? ?? '',
      sentTime:
          _parseSentTime(json[AppConstants.notificationSentTimeField]) ??
          DateTime.now(),
      data: json[AppConstants.notificationDataField] as Map<String, dynamic>?,
    );
  }

  static DateTime? _parseSentTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  NotificationEntity toEntity() => NotificationEntity(
    title: title,
    body: body,
    sentTime: sentTime,
    data: data,
  );

  @override
  List<Object?> get props => [title, body, sentTime, data];
}
