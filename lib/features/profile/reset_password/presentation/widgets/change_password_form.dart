import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'password_field.dart';
import 'update_password_button.dart';

class ChangePasswordForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const ChangePasswordForm({
    super.key,
    required this.formKey,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
  });

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  void _addListeners() {
    widget.currentPasswordController.addListener(_validateForm);
    widget.newPasswordController.addListener(_validateForm);
    widget.confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = widget.formKey.currentState?.validate() ?? false;
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  void dispose() {
    widget.currentPasswordController.removeListener(_validateForm);
    widget.newPasswordController.removeListener(_validateForm);
    widget.confirmPasswordController.removeListener(_validateForm);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Form(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: _validateForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PasswordField(
              controller: widget.currentPasswordController,
              labelText: AppStrings.currentPassword,
              validator: AppValidations.validatePassword,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16.h),
            PasswordField(
              controller: widget.newPasswordController,
              labelText: AppStrings.newPassword,
              validator: AppValidations.validatePassword,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16.h),
            PasswordField(
              controller: widget.confirmPasswordController,
              labelText: AppStrings.confirmPassword,
              validator: (v) => AppValidations.validateConfirmPassword(
                v,
                widget.newPasswordController.text,
              ),
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 40.h),
            UpdatePasswordButton(
              isFormValid: _isFormValid,
              formKey: widget.formKey,
              currentPassword: widget.currentPasswordController.text,
              newPassword: widget.newPasswordController.text,
            ),
          ],
        ),
      ),
    );
  }
}
