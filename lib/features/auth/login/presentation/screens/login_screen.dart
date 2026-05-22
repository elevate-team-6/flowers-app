import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/services/exit_app_dialog.dart';
import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_flower_loading.dart';
import 'package:flowers_app/core/widgets/rich_text_with_link.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_cubit.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_event.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_state.dart';
import 'package:flowers_app/features/auth/login/presentation/widgets/login_button.dart';
import 'package:flowers_app/features/auth/login/presentation/widgets/login_fields.dart';
import 'package:flowers_app/features/auth/login/presentation/widgets/remember_me_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context, LoginState state) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().add(
        LoginRequestedEvent(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          isRememberMe: state.isRememberMe,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await ExitAppDialog.show(context);
        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) {
          return previous.errorMessage != current.errorMessage ||
              previous.user != current.user ||
              previous.isLoading != current.isLoading;
        },
        listener: (context, state) {
          if (state.isLoading) {
            LoadingDialog.show(context: context);
          } else {
            LoadingDialog.hide(context: context);
          }
          final errorMessage = state.errorMessage;
          if (errorMessage != null && errorMessage.isNotEmpty) {
            SnackBarServices.showErrorMessage(state.errorMessage!);
          }
          if (state.user != null) {
            SnackBarServices.showSuccessMessage(AppStrings.loginSuccess.tr());

            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.mainLayout,
              (route) => false,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text(AppStrings.login.tr())),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 30.h),
                          LoginFields(
                            emailController: emailController,
                            passwordController: passwordController,
                            isPasswordObscure: state.isPasswordObscure,
                            onPasswordVisibilityToggle: () {
                              context.read<LoginCubit>().add(
                                const TogglePasswordVisibilityEvent(),
                              );
                            },
                          ),

                          SizedBox(height: 15.h),
                          RememberMeSection(
                            isChecked: state.isRememberMe,
                            onChanged: (value) {
                              context.read<LoginCubit>().add(
                                ToggleRememberMeEvent(value ?? false),
                              );
                            },
                            onForgotPasswordTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.forgotPassword,
                              );
                            },
                          ),

                          SizedBox(height: 60.h),
                          LoginButton(
                            onPressed: () {
                              _onLogin(context, state);
                            },
                          ),

                          SizedBox(height: 20.h),
                          RichTextWithLink(
                            textAlign: TextAlign.center,
                            linkTextColor: AppColors.primary,
                            normalText: AppStrings.dontHaveAccount.tr(),
                            linkText: AppStrings.signup.tr(),
                            onLinkTap: () {
                              Navigator.pushNamed(context, AppRoutes.signup);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
