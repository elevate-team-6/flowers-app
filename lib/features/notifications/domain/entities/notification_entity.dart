import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String title;
  final String body;
  final DateTime sentTime;
  final Map<String, dynamic>? data;

  const NotificationEntity({
    required this.title,
    required this.body,
    required this.sentTime,
    this.data,
  });

  @override
  List<Object?> get props => [title, body, sentTime, data];
}
