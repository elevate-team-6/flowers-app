import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/view_model/profile_cubit.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/view_model/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/services/snack_bar_services.dart';
import '../view_model/profile_events.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.logout.toUpperCase(),
              style: AppTextStyles.black18600,
            ),
            SizedBox(height: 8.h),
            Text(AppStrings.confirmLogout, style: AppTextStyles.black16400),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      side: const BorderSide(
                        color: AppColors.black10,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      AppStrings.cancel,
                      style: AppTextStyles.black14600,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                BlocConsumer<ProfileCubit, ProfileStates>(
                  listenWhen: (previous, current) =>
                      previous.logoutState.isLoading &&
                      !current.logoutState.isLoading,
                  buildWhen: (previous, current) =>
                      previous.logoutState != current.logoutState,
                  listener: (BuildContext context, ProfileStates state) {
                    if (state.logoutState.errorMessage != null) {
                      SnackBarServices.showErrorMessage(
                        state.logoutState.errorMessage!,
                      );
                      Navigator.pop(context);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    }
                  },
                  builder: (context, state) {
                    return Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ProfileCubit>().doEvent(LogoutEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          elevation: 0,
                        ),
                        child: state.logoutState.isLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppStrings.logout,
                                style: AppTextStyles.white14600,
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
