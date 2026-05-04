import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
    final bool isPasswordObscure;
  final VoidCallback onPasswordVisibilityToggle;
  const LoginTextField({super.key, required this.emailController, required this.passwordController, required this.isPasswordObscure, required this.onPasswordVisibilityToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: AppStrings.enterYourEmail,
            labelText: AppStrings.email,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: AppValidations.validateEmail,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: passwordController,
          obscureText: isPasswordObscure,
          decoration: InputDecoration(
            hintText: AppStrings.enterYourPassword,
            labelText: AppStrings.password,
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
