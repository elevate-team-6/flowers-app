import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GiftSection extends StatelessWidget {
  final bool isGift;
  final ValueChanged<bool> onChanged;
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const GiftSection({
    super.key,
    required this.isGift,
    required this.onChanged,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Switch(
              value: isGift,
              onChanged: onChanged,
              activeTrackColor: AppColors.primary,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor:AppColors.white80,
            ),
            Text(AppStrings.itIsGift.tr(), style: AppTextStyles.black18500),
          ],
        ),

        if (isGift) ...[
          SizedBox(height: 16.h),
          TextFormField(
            decoration: InputDecoration(
              labelText: AppStrings.name.tr(),
              hintText: AppStrings.enterName.tr(),
            ),
            validator: AppValidations.validateUserName,
            controller: nameController,
            keyboardType: TextInputType.name,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          TextFormField(
            decoration: InputDecoration(
              labelText: AppStrings.phoneNumber.tr(),
              hintText: AppStrings.enterThePhoneNumber.tr(),
            ),
            validator: AppValidations.validatePhoneNumber,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
          ),
        ],
      ],
    );
  }
}
