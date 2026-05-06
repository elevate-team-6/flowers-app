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
      listener: (context, state) {
        if (state.verifyResetCodeState.data != null &&
            !state.verifyResetCodeState.isLoading) {
          //hide the previous one
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.verifyResetCodeState.errorMessage ??
                    'verification code is correct',
              ),
              backgroundColor: AppColors.green,
            ),
          );
          AppRoutes.navigatorKey.currentState!.pushNamed(
            AppRoutes.resetPassword,
            arguments: widget.email,
          );
        }
        if (state.verifyResetCodeState.errorMessage != null) {
          setState(() {
            hasError = true;
          });
          //hide the previous one
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.verifyResetCodeState.errorMessage ?? 'Invalid code',
              ),
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
          title: Text(AppStrings.password, style: AppTextStyles.black20500),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 24),
              Text(
                AppStrings.emailVerification,
                style: AppTextStyles.black18500,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 44),
                child: Text(
                  AppStrings.emailVerificationSubtitle,
                  style: AppTextStyles.black13400,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              BlocBuilder<ForgotPasswordViewModel, ForgotPasswordStates>(
                builder: (context, state) {
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
                              VerifyResetCodeEvent(
                                email: widget.email,
                                resetCode: value,
                              ),
                            );
                          }
                        },
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.scale,
                        animationDuration: const Duration(milliseconds: 200),
                        textStyle: AppTextStyles.black20500,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 50,
                          fieldWidth: 50,
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
                          borderWidth: 1.5,
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
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                AppStrings.invalidCode,
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
              SizedBox(height: 24),
              RichTextWithLink(
                normalText: AppStrings.didntReceiveCode,
                linkText: AppStrings.resend,
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
