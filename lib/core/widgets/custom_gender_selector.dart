import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomGenderSelector extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?>? onChanged;

  const CustomGenderSelector({
    super.key,
    required this.selectedGender,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.gender,
          style: AppTextStyles.gray18500,
        ),

        SizedBox(width: 32.w),

        RadioGroup<String>(
          groupValue: selectedGender,
          onChanged: onChanged ?? (_) {},

          child: Row(
            children: [
              Transform.scale(
                scale: 1.3,
                child: Radio<String>(
                  value: AppStrings.femaleValue,
                ),
              ),

              Text(
                AppStrings.female,
                style: AppTextStyles.black14400,
              ),

              SizedBox(width: 16.w),

              Transform.scale(
                scale: 1.3,
                child: Radio<String>(
                  value: AppStrings.maleValue,
                ),
              ),

              Text(
                AppStrings.male,
                style: AppTextStyles.black14400,
              ),
            ],
          ),
        ),
      ],
    );
  }
}