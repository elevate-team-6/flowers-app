import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/cubit/forgot_password_view_model.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/states/forgot_password_events.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/states/forgot_password_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordViewModel, ForgotPasswordStates>(
      listener: (context, state) {
        if (state.resetPasswordState.data != null &&
            !state.resetPasswordState.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password reset successfully"),
              backgroundColor: AppColors.green,
            ),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        if (state.resetPasswordState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.resetPasswordState.errorMessage ?? 'Error occurred',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
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

                BlocBuilder<ForgotPasswordViewModel, ForgotPasswordStates>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state.resetPasswordState.isLoading
                            ? null
                            : () {
                                if (resetFormKey.currentState!.validate()) {
                                  context
                                      .read<ForgotPasswordViewModel>()
                                      .doEvent(
                                        ResetPasswordEvent(
                                          email: widget.email,
                                          password: passwordController.text,
                                          confirmPassword:
                                              confirmPasswordController.text,
                                        ),
                                      );
                                }
                              },
                        child: state.resetPasswordState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(AppStrings.continueText),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
