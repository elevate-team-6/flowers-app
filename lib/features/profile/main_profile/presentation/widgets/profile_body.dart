import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/logout_dialog.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/profile_header.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/profile_menu_item.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/profile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppColors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.profileDataState.errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.black16400,
                      ),
                      const SizedBox(height: 16),
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
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ProfileHeader(
            firstName: user?.firstName ?? "",
            lastName: user?.lastName ?? "",
            email: user?.email ?? "",
            image: user?.photo,
          ),
          const SizedBox(height: 20),
          ProfileMenuItem(
            title: AppStrings.myOrders.tr(),
            leading: SvgPicture.asset(AppIcons.orders, width: 24, height: 24),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ordersScreen);
            },
          ),
          const SizedBox(height: 5),
          ProfileMenuItem(
            title: AppStrings.savedAddress.tr(),
            leading: SvgPicture.asset(AppIcons.location, width: 24, height: 24),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.savedAddressScreen);
            },
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          ProfileMenuItem(
            title: AppStrings.notification.tr(),
            leading: SvgPicture.asset(AppIcons.orders, width: 24, height: 24),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notificationScreen);
            },
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          ProfileMenuItem(
            title: AppStrings.language.tr(),
            leading: SvgPicture.asset(AppIcons.language, width: 24, height: 24),
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
          const SizedBox(height: 5),
          ProfileMenuItem(
            title: AppStrings.aboutUs.tr(),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.aboutUsScreen);
            },
          ),
          const SizedBox(height: 5),
          ProfileMenuItem(
            title: AppStrings.termsAndConditions.tr(),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.termsAndConditions);
            },
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 10),
          ProfileMenuItem(
            title: AppStrings.logout.tr(),
            trailing: SvgPicture.asset(
              AppIcons.logout,
              width: 28,
              height: 28,
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
          const SizedBox(height: 10),
          Text(
            AppStrings.version.tr(),
            style: AppTextStyles.gray14400.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
