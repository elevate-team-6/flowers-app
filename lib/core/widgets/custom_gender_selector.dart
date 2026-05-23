import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomGenderSelector extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onChanged;

  const CustomGenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(AppStrings.gender.tr(), style: AppTextStyles.black18500),
        SizedBox(width: 32.w),
        RadioGroup<String>(
          groupValue: selectedGender,
          onChanged: onChanged,
          child: Row(
            children: [
              Radio<String>(
                value: AppStrings.femaleValue,
                activeColor: AppColors.primary,
              ),
              Text(AppStrings.female.tr(), style: AppTextStyles.black14400),
              SizedBox(width: 16.w),
              Radio<String>(
                value: AppStrings.maleValue,
                activeColor: AppColors.primary,
              ),
              Text(AppStrings.male.tr(), style: AppTextStyles.black14400),
            ],
          ),
        ),
      ],
    );
  }
}
