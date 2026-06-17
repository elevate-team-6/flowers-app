import 'dart:developer';

import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/widgets/custom_flower_loading.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/cubit/forgot_password_view_model.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/states/forgot_password_events.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/states/forgot_password_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordViewModel, ForgotPasswordStates>(
      listenWhen: (previous, current) {
        return previous.forgotPasswordState != current.forgotPasswordState;
      },
      listener: (context, state) {
        if (state.forgotPasswordState.isLoading) {
          LoadingDialog.show(context: context);
        } else {
          LoadingDialog.hide(context: context);
        }

        log("**********forgot password listner********");

        if (state.forgotPasswordState.data != null &&
            !state.forgotPasswordState.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.verificationCodeSentToYourEmail.tr()),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pushNamed(
            AppRoutes.verifyResetCode,
            arguments: emailController.text.trim(),
          );
        }
        if (state.forgotPasswordState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.forgotPasswordState.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.black,
            ),
          ),
          title: Text(
            AppStrings.password.tr(),
            style: AppTextStyles.black20500,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 24),
              Text(
                AppStrings.forgetPasswordTitle.tr(),
                style: AppTextStyles.black18500,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 44),
                child: Text(
                  AppStrings.forgetPasswordSubtitle.tr(),
                  style: AppTextStyles.black14400,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Form(
                key: emailFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: AppStrings.enterYourEmail.tr(),
                        label: Text(
                          AppStrings.email.tr(),
                          style: AppTextStyles.black13400,
                        ),
                        floatingLabelStyle: AppTextStyles.black13400,
                        filled: false,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) => AppValidations.validateEmail(value),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      onChanged: (_) {},
                    ),
                    SizedBox(height: 50),
                    BlocBuilder<ForgotPasswordViewModel, ForgotPasswordStates>(
                      buildWhen: (previous, current) {
                        return previous.forgotPasswordState !=
                            current.forgotPasswordState;
                      },
                      builder: (context, state) {
                        log("**********forgot password builder********");
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (emailFormKey.currentState!.validate()) {
                                context.read<ForgotPasswordViewModel>().doEvent(
                                  ForgotPasswordEvent(
                                    email: emailController.text.trim(),
                                  ),
                                );
                              }
                            },
                            child: Text(AppStrings.confirm.tr()),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
