import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/rich_text_with_link.dart';
import 'package:flowers_app/features/auth/login/domain/use_cases/login_use_case.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_cubit.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_event.dart';
import 'package:flowers_app/features/auth/login/presentation/view_model/login_state.dart';
import 'package:flowers_app/features/auth/login/presentation/widgets/login_button.dart';
import 'package:flowers_app/features/auth/login/presentation/widgets/login_text_field.dart';
import 'package:flowers_app/features/auth/login/presentation/widgets/remember_me_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowers_app/config/cache/cache_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isObscure = true;
  bool isChecked = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().add(
        LoginClicked(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          isRememberMe: isChecked
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(getIt<LoginUseCase>(),getIt<CacheHelper>(),),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            SnackBarServices.showErrorMessage(state.errorMessage!);
          }

          if (state.user != null) {
            SnackBarServices.showSuccessMessage(AppStrings.loginSuccess);
            Navigator.pushReplacementNamed(context, AppRoutes.register);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text(AppStrings.login)),
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
                          LoginTextField(
                            emailController: emailController,
                            passwordController: passwordController,
                            isPasswordObscure: state.isPasswordObscure,
                            onPasswordVisibilityToggle: () {
                              context.read<LoginCubit>().add(
                                const TogglePasswordVisibility(),
                              );
                            },
                          ),

                          SizedBox(height: 15.h),
                          RememberMeSection(
                            isChecked: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                            onForgotPasswordTap: () {},
                          ),

                          SizedBox(height: 60.h),
                          LoginButton(
                            isLoading: state.isLoading,
                            onPressed: () {
                              _onLogin(context);
                            },
                          ),

                          SizedBox(height: 20.h),
                          RichTextWithLink(
                            textAlign: TextAlign.center,
                            linkTextColor: AppColors.primary,
                            normalText: AppStrings.dontHaveAccount,
                            linkText: AppStrings.signup,
                            onLinkTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.register,
                              );
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
