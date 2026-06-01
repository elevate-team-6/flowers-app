import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDeliveryAddressSection extends StatelessWidget {
  const HomeDeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, color: AppColors.black50, size: 20.sp),
        SizedBox(width: 4),
        Text(
          AppStrings.deliverTo.tr(),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.black50,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(width: 4),
        Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 24.sp),
      ],
    );
  }
}
