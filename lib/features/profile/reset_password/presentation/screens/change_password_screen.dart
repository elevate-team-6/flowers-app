import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/widgets/custom_flower_loading.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_cubit.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_event.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_validateForm);
    _newPasswordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(AppStrings.resetPassword),
      ),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.loading) {
            LoadingDialog.show(context: context);
          } else {
            LoadingDialog.hide();
          }

          if (state.status == ChangePasswordStatus.success) {
            SnackBarServices.showSuccessMessage(
              AppStrings.passwordChangedSuccess,
            );
            Navigator.pop(context);
          } else if (state.status == ChangePasswordStatus.failure) {
            SnackBarServices.showErrorMessage(
              state.errorMessage ?? AppStrings.someThingWentWrong,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: _validateForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Password
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrent,
                    decoration: InputDecoration(
                      labelText: AppStrings.currentPassword,
                      hintText: AppStrings.currentPassword,
                      hintStyle: AppTextStyles.gray12400,
                      labelStyle: AppTextStyles.black14400,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrent
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20.sp,
                          color: AppColors.black30,
                        ),
                        onPressed: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                    ),
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    textInputAction: TextInputAction.next,
                    validator: AppValidations.validatePassword,
                  ),
                  SizedBox(height: 16.h),

                  // New Password
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    decoration: InputDecoration(
                      labelText: AppStrings.newPassword,
                      hintText: AppStrings.newPassword,
                      hintStyle: AppTextStyles.gray12400,
                      labelStyle: AppTextStyles.black14400,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNew
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20.sp,
                          color: AppColors.black30,
                        ),
                        onPressed: () =>
                            setState(() => _obscureNew = !_obscureNew),
                      ),
                    ),
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    textInputAction: TextInputAction.next,
                    validator: AppValidations.validatePassword,
                  ),
                  SizedBox(height: 16.h),

                  // Confirm Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      labelText: AppStrings.confirmPassword,
                      hintText: AppStrings.confirmPassword,
                      hintStyle: AppTextStyles.gray12400,
                      labelStyle: AppTextStyles.black14400,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20.sp,
                          color: AppColors.black30,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    textInputAction: TextInputAction.done,
                    validator: (v) => AppValidations.validateConfirmPassword(
                      v,
                      _newPasswordController.text,
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isFormValid
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ChangePasswordCubit>().doEvent(
                                  ChangePasswordEvent(
                                    currentPassword:
                                        _currentPasswordController.text,
                                    newPassword: _newPasswordController.text,
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid
                            ? AppColors.primary
                            : AppColors.black30,
                        disabledBackgroundColor: AppColors.black30,
                      ),
                      child: Text(AppStrings.update),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
