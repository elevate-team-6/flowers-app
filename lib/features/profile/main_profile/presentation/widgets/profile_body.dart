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
  final BuildContext context;
  final ProfileStates state;
  const ProfileBody({super.key, required this.context, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.profileDateState.isLoading) {
      return const ProfileShimmer();
    }

    if (state.profileDateState.errorMessage != null) {
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
                        state.profileDateState.errorMessage!,
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
                        child: const Text(
                          AppStrings.retry,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                        ),
                        onPressed: () {
                          //todo: logout
                        },
                        child: Text(
                          AppStrings.logout,
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

    final UserProfileEntity? user = state.profileDateState.data;

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
            title: AppStrings.myOrders,
            leading: SvgPicture.asset(AppIcons.orders, width: 24, height: 24),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ordersScreen);
            },
          ),
          const SizedBox(height: 5),
          ProfileMenuItem(
            title: AppStrings.savedAddress,
            leading: SvgPicture.asset(AppIcons.location, width: 24, height: 24),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.savedAddressScreen);
            },
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          ProfileMenuItem(
            title: AppStrings.notification,
            leading: SvgPicture.asset(AppIcons.orders, width: 24, height: 24),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notificationScreen);
            },
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          ProfileMenuItem(
            title: AppStrings.language,
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
            title: AppStrings.aboutUs,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.aboutUsScreen);
            },
          ),
          const SizedBox(height: 5),
          ProfileMenuItem(
            title: AppStrings.termsAndConditions,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.termsAndConditions);
            },
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 10),
          ProfileMenuItem(
            title: AppStrings.logout,
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
              //Todo: show dialog to confirm logout
            },
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.version,
            style: AppTextStyles.gray14400.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
