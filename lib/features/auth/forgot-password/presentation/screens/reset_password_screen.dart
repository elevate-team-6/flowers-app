import 'dart:developer';

import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_flower_loading.dart';
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
      listenWhen: (previous, current) {
        return previous.resetPasswordState != current.resetPasswordState;
      },
      listener: (context, state) {
        if (state.resetPasswordState.isLoading) {
          LoadingDialog.show(context: context);
        } else {
          LoadingDialog.hide(context: context);
        }
        log("**********reset password listner********");
        if (state.resetPasswordState.data != null &&
            !state.resetPasswordState.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.passwordResetSuccessfully),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pushNamed(AppRoutes.login);
        }
        if (state.resetPasswordState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.resetPasswordState.errorMessage!),
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
          title: const Text(
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
                const Text(
                  AppStrings.resetPasswordTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8),

                /// Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: const Text(
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  textInputAction: TextInputAction.done,
                  validator: (value) => AppValidations.validateConfirmPassword(
                    value,
                    passwordController.text,
                  ),
                ),

                SizedBox(height: 40),

                BlocBuilder<ForgotPasswordViewModel, ForgotPasswordStates>(
                  buildWhen: (previous, current) {
                    return previous.resetPasswordState !=
                        current.resetPasswordState;
                  },
                  builder: (context, state) {
                    log("**********verfiey code builder********");
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (resetFormKey.currentState!.validate()) {
                            context.read<ForgotPasswordViewModel>().doEvent(
                              ResetPasswordEvent(
                                email: widget.email,
                                password: passwordController.text,
                              ),
                            );
                          }
                        },
                        child: Text(AppStrings.continueText),
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
