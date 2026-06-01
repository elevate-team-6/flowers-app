import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/widgets/password_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  const EditProfileForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
  });
  void unfocus(_) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: AppStrings.firstName.tr(),
                ),
                validator: AppValidations.validateFirstName,
                controller: firstNameController,
                onTapOutside: unfocus,
                keyboardType: TextInputType.name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: AppStrings.lastName.tr(),
                ),
                validator: AppValidations.validateLastName,
                controller: lastNameController,
                onTapOutside: unfocus,
                keyboardType: TextInputType.name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(labelText: AppStrings.email.tr()),
          validator: AppValidations.validateEmail,
          controller: emailController,
          onTapOutside: unfocus,
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 24.h),
        TextFormField(
          decoration: InputDecoration(labelText: AppStrings.phoneNumber.tr()),
          validator: AppValidations.validatePhoneNumber,
          controller: phoneController,
          onTapOutside: unfocus,
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 24.h),
        TextFormField(
          decoration: InputDecoration(
            labelText: AppStrings.password.tr(),
            prefixIcon: const PasswordStars(),
            suffixIcon: TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.changePassword),
              child: Text(
                AppStrings.change.tr(),
                style: AppTextStyles.primary12600,
              ),
            ),
          ),
          readOnly: true,
        ),
      ],
    );
  }
}
