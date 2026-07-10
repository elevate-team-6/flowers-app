import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/services/external_lancher_service.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RiderInfoCard extends StatelessWidget {
  final String? riderName;
  final String? riderPhone;

  const RiderInfoCard({
    super.key,
    required this.riderName,
    required this.riderPhone,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = (riderName?.isNotEmpty ?? false)
        ? riderName!
        : AppStrings.riderNotAssigned.tr();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(color: AppColors.white),
      child: Row(
        children: [
          // ── Avatar ──────────────────────────────────────────
          Image.asset(
            AppIcons.deliveryBoy,
            width: 54.w,
            height: 54.w,
            fit: BoxFit.contain,
          ),

          SizedBox(width: 12.w),

          // ── Name & subtitle ──────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName, style: AppTextStyles.black14600),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.deliveryHero.tr(),
                  style: AppTextStyles.black13400,
                ),
              ],
            ),
          ),

          // ── Action Buttons ───────────────────────────────────
          IconButton(
            onPressed: () {
              ExternalLauncherService.makePhoneCall(
                context: context,
                phone: riderPhone ?? '',
              );
            },
            icon: Image.asset(
              AppIcons.phoneCall,
              width: 24.w,
              height: 24.w,
              color: AppColors.primary,
            ),
          ),
          IconButton(
            onPressed: () {
              ExternalLauncherService.openWhatsApp(
                context: context,
                phone: riderPhone ?? '',
              );
            },
            icon: Image.asset(
              AppIcons.whatsApp,
              width: 24.w,
              height: 24.w,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
