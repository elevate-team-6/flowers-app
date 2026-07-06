import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// خطوة واحدة في الـ timeline بتاع تتبع الأوردر (دائرة + خط واصل + عنوان + وقت).
class TrackingStepTile extends StatelessWidget {
  final String title;
  final String? timeLabel;

  /// الخطوة اتوصلها (الحالة الحالية أو قبلها).
  final bool isReached;

  /// آخر خطوة وصلها الأوردر دلوقتي.
  final bool isCurrent;
  final bool isLast;

  const TrackingStepTile({
    super.key,
    required this.title,
    this.timeLabel,
    required this.isReached,
    required this.isCurrent,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.black10;
    final dotColor = isReached ? activeColor : inactiveColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20.r,
                height: 20.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isReached ? activeColor : AppColors.white,
                  border: Border.all(color: dotColor, width: 2),
                ),
                child: isCurrent
                    ? Center(
                        child: Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                        ),
                      )
                    : (isReached
                          ? Icon(
                              Icons.check,
                              size: 12.r,
                              color: AppColors.white,
                            )
                          : null),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: isReached ? activeColor : inactiveColor,
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isReached
                      ? AppTextStyles.black14600
                      : AppTextStyles.gray14400,
                ),
                if (timeLabel != null && timeLabel!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(timeLabel!, style: AppTextStyles.gray12400),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
