import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final resetFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void onSubmit() {
    if (resetFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password validated successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
          ),
        ),
        title: Text(
          AppStrings.password,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: resetFormKey,
          child: Column(
            children: [
              SizedBox(height: 24),

              /// Title
              Text(
                AppStrings.resetPasswordTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),

              /// Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  AppStrings.resetPasswordSubtitle,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 32),

              /// New Password
              TextFormField(
                controller: passwordController,

                obscureText: true,
                decoration: InputDecoration(
                  hintText: AppStrings.enterYourPassword,
                  label: Text(
                    AppStrings.newPassword,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  floatingLabelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) => AppValidations.validatePassword(value),
              ),

              SizedBox(height: 24),

              /// Confirm Password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: AppStrings.confirmPassword,
                  label: Text(
                    AppStrings.confirmPassword,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  floatingLabelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                textInputAction: TextInputAction.done,
                validator: (value) => AppValidations.validateConfirmPassword(
                  value,
                  passwordController.text,
                ),
              ),

              SizedBox(height: 40),

              /// Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  child: Text(AppStrings.continueText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
