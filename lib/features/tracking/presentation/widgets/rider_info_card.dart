import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/services/external_lancher_service.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/tracking/presentation/widgets/tracking_action_button.dart';
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
      padding: EdgeInsets.all(16.w),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.white,
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Image.asset(
                AppIcons.deliveryBoy,
                width: 30.sp,
                height: 30.sp,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: AppTextStyles.black14400.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.deliveryHero.tr(),
                  style: AppTextStyles.gray12400,
                ),
              ],
            ),
          ),
          TrackingActionButton(
            iconPath: AppIcons.phoneCall,
            onTap: () {
              ExternalLauncherService.makePhoneCall(
                context: context,
                phone: riderPhone ?? '',
              );
            },
          ),
          SizedBox(width: 8.w),
          TrackingActionButton(
            iconPath: AppIcons.whatsApp,
            onTap: () {
              ExternalLauncherService.openWhatsApp(
                context: context,
                phone: riderPhone ?? '',
              );
            },
          ),
        ],
      ),
    );
  }
}
