import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/auth/login/domain/use_cases/login_use_case.dart';
import 'package:flowers_app/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:flowers_app/features/auth/login/presentation/bloc/login_event.dart';
import 'package:flowers_app/features/auth/login/presentation/bloc/login_state.dart';
import 'package:flowers_app/features/auth/login/presentation/widgets/login_button.dart';
import 'package:flowers_app/features/auth/login/presentation/widgets/login_text_field.dart';
import 'package:flowers_app/features/auth/login/presentation/widgets/remember_me_section.dart';
import 'package:flutter/material.dart';
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
      context.read<LoginBloc>().add(
        LoginClicked(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(getIt<LoginUseCase>()), 
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            SnackBarServices.showErrorMessage(state.errorMessage!);
          }

          if (state.user != null) {
            SnackBarServices.showSuccessMessage("Login Success 🎉");
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.register,
  );
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
                  child: BlocBuilder<LoginBloc, LoginState>(
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
                              context.read<LoginBloc>().add(
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.dontHaveAccount,
                                style: AppTextStyles.black16400,
                              ),
                              Text(
                                AppStrings.signup,
                                style: AppTextStyles.primary16400.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
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
