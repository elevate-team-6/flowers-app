import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:flowers_app/features/notifications/presentation/view_model/notifications_state.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBadgeListener extends StatefulWidget {
  const NotificationBadgeListener({super.key});

  @override
  State<NotificationBadgeListener> createState() =>
      _NotificationBadgeListenerState();
}

class _NotificationBadgeListenerState extends State<NotificationBadgeListener> {
  @override
  void initState() {
    super.initState();
    getIt<NotificationsCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      bloc: getIt<NotificationsCubit>(),
      builder: (context, state) {
        return NotificationBadge(
          count: state.unreadCount.toString(),
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.notificationScreen);
          },
        );
      },
    );
  }
}
