import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordObscure;
  final VoidCallback onPasswordVisibilityToggle;
  const LoginFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordObscure,
    required this.onPasswordVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: emailController,
          decoration: InputDecoration(
            hintText: AppStrings.enterYourEmail.tr(),
            labelText: AppStrings.email.tr(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: AppValidations.validateEmail,
        ),
        const SizedBox(height: 20),
        TextFormField(
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: passwordController,
          obscureText: isPasswordObscure,
          decoration: InputDecoration(
            hintText: AppStrings.enterYourPassword.tr(),
            labelText: AppStrings.password.tr(),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordObscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.gray,
              ),
              onPressed: onPasswordVisibilityToggle,
            ),
          ),
          validator: AppValidations.validatePassword,
        ),
      ],
    );
  }
}
