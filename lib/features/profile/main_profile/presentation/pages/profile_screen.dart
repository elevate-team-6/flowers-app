import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/view_model/profile_cubit.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/view_model/profile_events.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/view_model/profile_states.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/notification_badge.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/widgets/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProfileCubit>()..doEvent(const GetProfileDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
          title: Row(
            children: [
              SvgPicture.asset(AppIcons.flowerAppIcon, width: 24, height: 24),
              Text(
                AppStrings.flowery,
                style: AppTextStyles.primary20400imFellEnglish,
              ),
            ],
          ),
          actions: [
            NotificationBadge(
              count: '3',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.notificationScreen);
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                final cubit = context.read<ProfileCubit>();
                cubit.doEvent(const GetProfileDataEvent());
                await cubit.stream.firstWhere(
                  (state) => !state.profileDateState.isLoading,
                );
              },
              child: ProfileBody(context: context, state: state),
            );
          },
        ),
      ),
    );
  }
}
