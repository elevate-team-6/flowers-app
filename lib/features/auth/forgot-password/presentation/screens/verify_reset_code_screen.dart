import 'dart:developer';

import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/cubit/forgot_password_view_model.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/states/forgot_password_events.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/view_model/states/forgot_password_states.dart';
import 'package:flowers_app/features/auth/forgot-password/presentation/widgets/rich_text_with_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyResetCodeScreen extends StatefulWidget {
  final String email;
  const VerifyResetCodeScreen({super.key, required this.email});

  @override
  State<VerifyResetCodeScreen> createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends State<VerifyResetCodeScreen> {
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordViewModel, ForgotPasswordStates>(
      listenWhen: (previous, current) {
        return previous.verifyResetCodeState != current.verifyResetCodeState;
      },
      listener: (context, state) {
        log("**********verfiey code listner********");
        if (state.verifyResetCodeState.data != null &&
            !state.verifyResetCodeState.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.verifyResetCodeState.errorMessage ??
                    AppStrings.verificationCodeIsCorrect.tr(),
              ),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(
            context,
          ).pushNamed(AppRoutes.resetPassword, arguments: widget.email);
        }
        if (state.verifyResetCodeState.errorMessage != null) {
          setState(() {
            hasError = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.verifyResetCodeState.errorMessage!),
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
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              Text(
                AppStrings.emailVerification.tr(),
                style: AppTextStyles.black18500,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 44.w),
                child: Text(
                  AppStrings.emailVerificationSubtitle.tr(),
                  style: AppTextStyles.black13400,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32.h),
              BlocBuilder<ForgotPasswordViewModel, ForgotPasswordStates>(
                buildWhen: (previous, current) {
                  return previous.verifyResetCodeState !=
                      current.verifyResetCodeState;
                },
                builder: (context, state) {
                  log("**********verfiey code builder********");
                  return Column(
                    children: [
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        onChanged: (value) {
                          if (hasError) {
                            setState(() {
                              hasError = false;
                            });
                          }
                        },
                        onCompleted: (value) {
                          if (!state.verifyResetCodeState.isLoading) {
                            context.read<ForgotPasswordViewModel>().doEvent(
                              VerifyResetCodeEvent(resetCode: value),
                            );
                          }
                        },
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.scale,
                        animationDuration: const Duration(milliseconds: 200),
                        textStyle: AppTextStyles.black20500,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10.r),
                          fieldHeight: 50.h,
                          fieldWidth: 50.w,
                          activeFillColor: hasError
                              ? AppColors.white
                              : AppColors.white60,
                          inactiveFillColor: hasError
                              ? AppColors.white
                              : AppColors.white60,
                          selectedFillColor: hasError
                              ? AppColors.white
                              : AppColors.white60,
                          activeColor: hasError
                              ? AppColors.error
                              : AppColors.white60,
                          inactiveColor: hasError
                              ? AppColors.error
                              : AppColors.white60,
                          selectedColor: hasError
                              ? AppColors.error
                              : AppColors.blue,
                          borderWidth: 1.5.w,
                        ),
                        enableActiveFill: true,
                        cursorColor: AppColors.blue,
                      ),
                      if (hasError)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 16.r,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                AppStrings.invalidCode.tr(),
                                style: AppTextStyles.black13400.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
              SizedBox(height: 24.h),
              RichTextWithLink(
                normalText: AppStrings.didntReceiveCode.tr(),
                linkText: AppStrings.resend.tr(),
                onLinkTap: () {
                  context.read<ForgotPasswordViewModel>().doEvent(
                    ForgotPasswordEvent(email: widget.email),
                  );
                },
                linkTextColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
