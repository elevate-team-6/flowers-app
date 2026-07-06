import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/logout_dialog.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/profile_header.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/profile_menu_item.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../view_model/profile_cubit.dart';
import '../view_model/profile_events.dart';
import '../view_model/profile_states.dart';
import 'language_bottom_sheet.dart';

class ProfileBody extends StatelessWidget {
  final ProfileStates state;
  const ProfileBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.profileDataState.isLoading) {
      return const ProfileShimmer();
    }

    if (state.profileDataState.errorMessage != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(48.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60.r,
                        color: AppColors.red,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        state.profileDataState.errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.black16400,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          context.read<ProfileCubit>().doEvent(
                            const GetProfileDataEvent(),
                          );
                        },
                        child: Text(
                          AppStrings.retry.tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => BlocProvider.value(
                              value: context.read<ProfileCubit>(),
                              child: const LogoutDialog(),
                            ),
                          );
                        },
                        child: Text(
                          AppStrings.logout.tr(),
                          style: AppTextStyles.white16500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    final UserProfileEntity? user = state.profileDataState.data;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          ProfileHeader(user: user),
          SizedBox(height: 20.h),
          ProfileMenuItem(
            title: AppStrings.myOrders.tr(),
            leading: SvgPicture.asset(
              AppIcons.orders,
              width: 24.w,
              height: 24.h,
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.orders);
            },
          ),
          SizedBox(height: 5.h),
          ProfileMenuItem(
            title: AppStrings.savedAddress.tr(),
            leading: SvgPicture.asset(
              AppIcons.location,
              width: 24.w,
              height: 24.h,
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.savedAddressScreen);
            },
          ),
          SizedBox(height: 10.h),
          const Divider(),
          SizedBox(height: 10.h),
          ProfileMenuItem(
            title: AppStrings.notification.tr(),
            leading: SizedBox(
              height: 20.h,
              child: Switch.adaptive(
                value: state.isNotificationEnabled,
                onChanged: (value) {
                  context.read<ProfileCubit>().doEvent(
                    ToggleNotificationEvent(value),
                  );
                },
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notificationScreen);
            },
          ),
          SizedBox(height: 10.h),
          const Divider(),
          SizedBox(height: 10.h),
          ProfileMenuItem(
            title: AppStrings.language.tr(),
            leading: SvgPicture.asset(
              AppIcons.language,
              width: 24.w,
              height: 24.h,
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (innerContext) => BlocProvider.value(
                  value: context.read<ProfileCubit>(),
                  child: const LanguageBottomSheet(),
                ),
              );
            },
          ),
          SizedBox(height: 5.h),
          ProfileMenuItem(
            title: AppStrings.aboutUs.tr(),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.aboutUsScreen);
            },
          ),
          SizedBox(height: 5.h),
          ProfileMenuItem(
            title: AppStrings.termsAndConditions.tr(),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.termsAndConditions);
            },
          ),
          SizedBox(height: 5.h),
          const Divider(),
          SizedBox(height: 10.h),
          ProfileMenuItem(
            title: AppStrings.logout.tr(),
            trailing: SvgPicture.asset(
              AppIcons.logout,
              width: 28.w,
              height: 28.h,
              colorFilter: const ColorFilter.mode(
                AppColors.red,
                BlendMode.srcIn,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: context.read<ProfileCubit>(),
                  child: const LogoutDialog(),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          Text(
            AppStrings.version.tr(),
            style: AppTextStyles.gray14400.copyWith(fontSize: 11.sp),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
