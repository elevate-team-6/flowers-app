import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyAddressesView extends StatelessWidget {
  const EmptyAddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: const BoxDecoration(
              color: AppColors.white50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_off_outlined,
              size: 64.r,
              color: AppColors.black30,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            AppStrings.noAddressesSaved.tr(),
            style: AppTextStyles.black16600.copyWith(color: AppColors.black40),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.startAddingAddresses.tr(),
            style: AppTextStyles.gray14400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
