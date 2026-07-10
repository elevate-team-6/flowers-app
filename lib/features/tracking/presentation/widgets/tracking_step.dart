import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isLast;

  const TrackingStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Indicator + Line ───────────────────────────────
          Column(
            children: [
              _StepIndicator(isCompleted: isCompleted),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    color: isCompleted ? AppColors.primary : AppColors.gray,
                  ),
                ),
            ],
          ),

          SizedBox(width: 16.w),

          // ── Title + Subtitle ───────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: isCompleted
                        ? AppTextStyles.black14400.copyWith(
                            fontWeight: FontWeight.w600,
                          )
                        : AppTextStyles.gray14400,
                  ),
                  SizedBox(height: 4.h),
                  Text(subtitle, style: AppTextStyles.gray12400),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final bool isCompleted;

  const _StepIndicator({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(
          color: isCompleted ? AppColors.primary : AppColors.gray,
          width: 2.w,
        ),
      ),
      child: isCompleted
          ? Center(
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            )
          : null,
    );
  }
}
