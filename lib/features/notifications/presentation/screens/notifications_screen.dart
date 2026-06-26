import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_error_state_view.dart';
import 'package:flowers_app/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:flowers_app/features/notifications/presentation/view_model/notifications_state.dart';
import 'package:flowers_app/features/notifications/presentation/widgets/empty_notifications_view.dart';
import 'package:flowers_app/features/notifications/presentation/widgets/notification_card.dart';
import 'package:flowers_app/features/notifications/presentation/widgets/notifications_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(AppStrings.notification.tr()),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.status == NotificationsStatus.loading) {
            return const NotificationsShimmer();
          }

          if (state.status == NotificationsStatus.failure) {
            return CustomErrorStateView(
              message:
                  state.errorMessage ?? AppStrings.somethingWentWrong.tr(),
              onRetry: () =>
                  context.read<NotificationsCubit>().getNotifications(),
            );
          }

          if (state.notifications.isEmpty) {
            return const EmptyNotificationsView();
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: state.notifications.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return NotificationCard(notification: state.notifications[index]);
            },
          );
        },
      ),
    );
  }
}
