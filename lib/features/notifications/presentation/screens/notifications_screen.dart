import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/widgets/custom_empty_state_view.dart';
import 'package:flowers_app/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:flowers_app/features/notifications/presentation/view_model/notifications_state.dart';
import 'package:flowers_app/features/notifications/presentation/widgets/notification_card.dart';
import 'package:flowers_app/features/notifications/presentation/widgets/notifications_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_error_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    _loadAndMarkOpened();
  }

  Future<void> _loadAndMarkOpened() async {
    final cubit = context.read<NotificationsCubit>();
    await cubit.getNotifications();
    await cubit.markNotificationsAsOpened();
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
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state.notifications.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () =>
                    context.read<NotificationsCubit>().clearNotifications(),
                child: Text(
                  AppStrings.clearAll.tr(),
                  style: AppTextStyles.primary14500,
                ),
              );
            },
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 16.w),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.status == NotificationsStatus.loading) {
            return const NotificationsShimmer();
          }

          if (state.status == NotificationsStatus.failure) {
            return CustomErrorState(
              message: state.errorMessage ?? AppStrings.somethingWentWrong.tr(),
              onRetry: () =>
                  context.read<NotificationsCubit>().getNotifications(),
            );
          }

          if (state.notifications.isEmpty) {
            return CustomEmptyStateView(
              message: AppStrings.noNotifications.tr(),
              subtitle: AppStrings.noNotificationsSubtitle.tr(),
              lottiePath: AppLottie.emptyMessages,
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
