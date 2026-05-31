import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomErrorStateView extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback onRetry;

  const CustomErrorStateView({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon = Icons.wifi_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72.sp, color: AppColors.black30),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.black16400.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(AppStrings.retry.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
