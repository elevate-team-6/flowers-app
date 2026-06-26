import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.toString();
    final formattedTime = DateFormat(
      'dd MMM yyyy, hh:mm a',
      locale,
    ).format(notification.sentTime);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Bell Icon ─────────────────────────────────────
              Padding(
                padding: EdgeInsets.only(top: 2.h, right: 10.w),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 22.sp,
                  color: AppColors.black30,
                ),
              ),

              // ── Content ───────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: AppTextStyles.black14400.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      notification.body,
                      style: AppTextStyles.gray14400,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      formattedTime,
                      style: AppTextStyles.gray12400.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.black30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Full-width Divider ─────────────────────────────────
        Divider(height: 0, thickness: 0.5.w, color: AppColors.white90),
      ],
    );
  }
}
