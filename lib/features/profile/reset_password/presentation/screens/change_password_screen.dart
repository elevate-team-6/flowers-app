import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_flower_loading.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_cubit.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_state.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/widgets/change_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: Text(AppStrings.resetPassword.tr()),
      ),
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.loading) {
            LoadingDialog.show(context: context);
          } else {
            LoadingDialog.hide();
          }

          if (state.status == ChangePasswordStatus.success) {
            SnackBarServices.showSuccessMessage(
              AppStrings.passwordChangedSuccess.tr(),
            );
            Navigator.pop(context); // ← يرجع لشاشة الـ Edit Profile
          } else if (state.status == ChangePasswordStatus.failure) {
            SnackBarServices.showErrorMessage(
              state.errorMessage ?? AppStrings.someThingWentWrong.tr(),
            );
          }
        },
        child: ChangePasswordForm(
          formKey: _formKey,
          currentPasswordController: _currentPasswordController,
          newPasswordController: _newPasswordController,
          confirmPasswordController: _confirmPasswordController,
        ),
      ),
    );
  }
}
