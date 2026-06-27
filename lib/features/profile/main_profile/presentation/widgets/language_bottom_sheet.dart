import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/config/services/firebase_service.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.changeLanguage.tr(),
            style: AppTextStyles.primary20700,
          ),
          SizedBox(height: 20.h),
          _buildLanguageItem(
            context: context,
            title: AppStrings.arabic.tr(),
            isSelected: currentLocale == 'ar',
            onSelect: () {
              context.setLocale(const Locale('ar'));
              getIt<FirebaseService>().updateUserLanguage('ar');
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 12.h),
          _buildLanguageItem(
            context: context,
            title: AppStrings.english.tr(),
            isSelected: currentLocale == 'en',
            onSelect: () {
              context.setLocale(const Locale('en'));
              getIt<FirebaseService>().updateUserLanguage('en');
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildLanguageItem({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return InkWell(
      onTap: isSelected ? null : onSelect,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.white60,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.black16600.copyWith(
                color: isSelected ? AppColors.primary : AppColors.black,
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
