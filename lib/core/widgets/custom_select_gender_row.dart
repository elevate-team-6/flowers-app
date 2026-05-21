import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSelectGenderRow extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onChanged;

  const CustomSelectGenderRow({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(AppStrings.gender, style: AppTextStyles.gray18500),

        SizedBox(width: 32.w),

        RadioGroup<String>(
          groupValue: selectedGender,
          onChanged: onChanged,

          child: Row(
            children: [
              Transform.scale(
                scale: 1.3,
                child: Radio<String>(
                  value: 'female',
                  activeColor: AppColors.primary,
                  fillColor: WidgetStatePropertyAll(AppColors.primary),
                ),
              ),

              Text(AppStrings.female, style: AppTextStyles.black14400),

              SizedBox(width: 16.w),

              Transform.scale(
                scale: 1.3,
                child: Radio<String>(
                  value: 'male',
                  activeColor: AppColors.primary,
                  fillColor: WidgetStatePropertyAll(AppColors.primary),
                ),
              ),

              Text(AppStrings.male, style: AppTextStyles.black14400),
            ],
          ),
        ),
      ],
    );
  }
}