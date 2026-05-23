import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/widgets/custom_flower_loading.dart';
import 'package:flowers_app/core/widgets/rich_text_with_link.dart';
import 'package:flowers_app/features/auth/signup/data/models/requestes/signup_request.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_cubit.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_events.dart';
import 'package:flowers_app/features/auth/signup/presentation/view_model/signup_states.dart';
import 'package:flowers_app/features/auth/signup/presentation/widgets/custom_text_field.dart';
import 'package:flowers_app/core/widgets/custom_gender_selector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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

  void _onSignup() {
    final isFormValid = _formKey.currentState!.validate();
    final isGenderSelected = _selectedGender != null;

    if (!isGenderSelected) {
      SnackBarServices.showErrorMessage(AppStrings.pleaseSelectGender.tr());
    }
    if (!isFormValid || !isGenderSelected) {
      return;
    }
    context.read<SignupCubit>().doEvent(
      SignupEvent(
        SignupRequest(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rePassword: _confirmPasswordController.text,
          phone: _phoneController.text.trim(),
          gender: _selectedGender!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.signupWithSpace.tr()),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.signupState.isLoading) {
            LoadingDialog.show(context: context);
          } else {
            LoadingDialog.hide();
          }
          if (state.signupState.data != null) {
            SnackBarServices.showSuccessMessage(AppStrings.registerSuccess.tr());
            Navigator.pop(context);
          } else if (state.signupState.errorMessage != null) {
            SnackBarServices.showErrorMessage(state.signupState.errorMessage!);
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
                        child: CustomTextField(
                          controller: _firstNameController,
                          labelText: AppStrings.firstName.tr(),
                          hintText: AppStrings.enterFirstName.tr(),
                          validator: AppValidations.validateFirstName,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomTextField(
                          controller: _lastNameController,
                          labelText: AppStrings.lastName.tr(),
                          hintText: AppStrings.enterLastName.tr(),
                          validator: AppValidations.validateLastName,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: _emailController,
                    labelText: AppStrings.email.tr(),
                    hintText: AppStrings.enterYourEmail.tr(),
                    keyboardType: TextInputType.emailAddress,
                    validator: AppValidations.validateEmail,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _passwordController,
                          labelText: AppStrings.password.tr(),
                          hintText: AppStrings.enterYourPassword.tr(),
                          obscureText: _obscurePassword,
                          validator: AppValidations.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20.sp,
                              color: AppColors.black30,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomTextField(
                          controller: _confirmPasswordController,
                          labelText: AppStrings.confirmPassword.tr(),
                          hintText: AppStrings.confirmPassword.tr(),
                          obscureText: _obscureConfirmPassword,
                          validator: (v) =>
                              AppValidations.validateConfirmPassword(
                                v,
                                _passwordController.text,
                              ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20.sp,
                              color: AppColors.black30,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: _phoneController,
                    labelText: AppStrings.phoneNumber.tr(),
                    hintText: AppStrings.enterPhoneNumber.tr(),
                    keyboardType: TextInputType.phone,
                    validator: AppValidations.validatePhoneNumber,
                  ),
                  SizedBox(height: 16.h),
                  CustomGenderSelector(
                    selectedGender: _selectedGender,
                    onChanged: (v) => setState(() => _selectedGender = v),
                  ),
                  SizedBox(height: 16.h),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.gray12400,
                      children: [
                        TextSpan(text: AppStrings.creatingAccountAgreement.tr()),
                        TextSpan(
                          text: AppStrings.termsAndConditions.tr(),
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
                    onPressed: state.signupState.isLoading ? null : _onSignup,
                    child: Text(AppStrings.signupWithSpace.tr()),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: RichTextWithLink(
                      normalText: AppStrings.alreadyHaveAccount.tr(),
                      linkText: AppStrings.login.tr(),
                      linkTextColor: AppColors.primary,
                      onLinkTap: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
