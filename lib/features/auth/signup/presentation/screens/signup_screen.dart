import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/widgets/rich_text_with_link.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_cubit.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_events.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_states.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';

import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignupCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.signupWithSpace),
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.signupState.isLoading) return;

            if (state.signupState.data != null) {
              SnackBarServices.showSuccessMessage(AppStrings.registerSuccess);

              Navigator.pop(context);
            } else if (state.signupState.errorMessage != null) {
              SnackBarServices.showErrorMessage(
                state.signupState.errorMessage!,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: AppStrings.firstName,
                              hintText: AppStrings.enterFirstName,
                              hintStyle: AppTextStyles.gray12400,
                              labelStyle: AppTextStyles.black14400,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                                borderSide: BorderSide(
                                  color: AppColors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onTapOutside: (event) =>
                                FocusManager().primaryFocus?.unfocus(),
                            textInputAction: TextInputAction.next,
                            validator: AppValidations.validateFirstName,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: AppStrings.lastName,
                              hintText: AppStrings.enterLastName,
                              hintStyle: AppTextStyles.gray12400,
                              labelStyle: AppTextStyles.black14400,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                                borderSide: BorderSide(
                                  color: AppColors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onTapOutside: (event) =>
                                FocusManager().primaryFocus?.unfocus(),
                            textInputAction: TextInputAction.next,
                            validator: AppValidations.validateLastName,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: AppStrings.email,
                        hintText: AppStrings.enterYourEmail,
                        hintStyle: AppTextStyles.gray12400,
                        labelStyle: AppTextStyles.black14400,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.r),
                          borderSide: BorderSide(
                            color: AppColors.black,
                            width: 1,
                          ),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTapOutside: (event) =>
                          FocusManager().primaryFocus?.unfocus(),
                      textInputAction: TextInputAction.next,
                      validator: AppValidations.validateEmail,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: AppStrings.password,
                              hintText: AppStrings.enterYourPassword,
                              hintStyle: AppTextStyles.gray12400,
                              labelStyle: AppTextStyles.black14400,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                                borderSide: BorderSide(
                                  color: AppColors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onTapOutside: (event) =>
                                FocusManager().primaryFocus?.unfocus(),
                            textInputAction: TextInputAction.next,
                            validator: AppValidations.validatePassword,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: AppStrings.confirmPassword,
                              hintText: AppStrings.confirmPassword,
                              hintStyle: AppTextStyles.gray12400,
                              labelStyle: AppTextStyles.black14400,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                                borderSide: BorderSide(
                                  color: AppColors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onTapOutside: (event) =>
                                FocusManager().primaryFocus?.unfocus(),
                            textInputAction: TextInputAction.next,
                            validator: (v) =>
                                AppValidations.validateConfirmPassword(
                                  v,
                                  _passwordController.text,
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: AppStrings.phoneNumber,
                        hintText: AppStrings.enterPhoneNumber,
                        hintStyle: AppTextStyles.gray12400,
                        labelStyle: AppTextStyles.black14400,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.r),
                          borderSide: BorderSide(
                            color: AppColors.black,
                            width: 1,
                          ),
                        ),
                      ),

                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTapOutside: (event) =>
                          FocusManager().primaryFocus?.unfocus(),
                      textInputAction: TextInputAction.next,
                      validator: AppValidations.validatePhoneNumber,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Text('Gender', style: AppTextStyles.black18500),
                        SizedBox(width: 32.w),
                        StatefulBuilder(
                          builder: (context, setRadioState) => Row(
                            children: [
                              Radio<String>(
                                value: 'female',
                                activeColor: AppColors.primary,
                                groupValue: _selectedGender,
                                onChanged: (v) =>
                                    setRadioState(() => _selectedGender = v),
                              ),
                              Text('Female', style: AppTextStyles.black14400),
                              SizedBox(width: 16.w),
                              Radio<String>(
                                value: 'male',
                                activeColor: AppColors.primary,
                                groupValue: _selectedGender,
                                onChanged: (v) =>
                                    setRadioState(() => _selectedGender = v),
                              ),
                              Text('Male', style: AppTextStyles.black14400),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.gray12400,
                        children: [
                          const TextSpan(
                            text: 'Creating an account, you agree to our ',
                          ),
                          TextSpan(
                            text: 'Terms&Conditions',
                            style: AppTextStyles.black12600.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.termsAndConditions,
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    ElevatedButton(
                      onPressed: state.signupState.isLoading
                          ? null
                          : () {
                              if (_selectedGender == null) {
                                SnackBarServices.showErrorMessage(
                                  'Please select a gender',
                                );
                                return;
                              }
                              if (_formKey.currentState!.validate()) {
                                context.read<SignupCubit>().doEvent(
                                  SignupEvent(
                                    SignupRequest(
                                      firstName: _firstNameController.text
                                          .trim(),
                                      lastName: _lastNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                      rePassword:
                                          _confirmPasswordController.text,
                                      phone: _phoneController.text.trim(),
                                      gender: _selectedGender!,
                                    ),
                                  ),
                                );
                              }
                            },
                      child: state.signupState.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(AppStrings.signupWithSpace),
                    ),
                    SizedBox(height: 16.h),
                    Center(
                      child: RichTextWithLink(
                        normalText: AppStrings.alreadyHaveAccount,
                        linkText: AppStrings.login,
                        linkTextColor: AppColors.primary,
                        onLinkTap: () =>
                            Navigator.pushNamed(context, AppRoutes.login),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
