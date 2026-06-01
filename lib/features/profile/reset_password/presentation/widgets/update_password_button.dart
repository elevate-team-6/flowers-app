import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_cubit.dart';
import 'package:flowers_app/features/profile/reset_password/presentation/view_model/change_password_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePasswordButton extends StatelessWidget {
  final bool isFormValid;
  final GlobalKey<FormState> formKey;
  final String currentPassword;
  final String newPassword;

  const UpdatePasswordButton({
    super.key,
    required this.isFormValid,
    required this.formKey,
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isFormValid
            ? () {
                if (formKey.currentState!.validate()) {
                  context.read<ChangePasswordCubit>().doEvent(
                    ChangePasswordEvent(
                      currentPassword: currentPassword,
                      newPassword: newPassword,
                    ),
                  );
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid ? AppColors.primary : AppColors.black30,
          disabledBackgroundColor: AppColors.black30,
        ),
        child: Text(AppStrings.update.tr()),
      ),
    );
  }
}
