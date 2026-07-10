import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EstimatedArrivalSection extends StatelessWidget {
  const EstimatedArrivalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.estimatedArrival.tr(),
                style: AppTextStyles.gray14400,
              ),
              SizedBox(height: 8.h),
              Text('03 Sep 2024, 11:00 AM', style: AppTextStyles.black16600),
            ],
          ),
        ),
        Divider(height: 32.h, thickness: 1, color: AppColors.black10),
      ],
    );
  }
}
