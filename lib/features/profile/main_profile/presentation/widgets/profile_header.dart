import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/screens/edit_profile_screen.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:flowers_app/features/profile/main_profile/domain/entities/user_profile_entity.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/view_model/profile_cubit.dart';
import 'package:flowers_app/features/profile/main_profile/presentation/view_model/profile_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/widgets/custom_cached_image.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileEntity? user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.white60,
          child: user?.photo != null && user!.photo!.startsWith('http')
              ? ClipOval(
                  child: CustomCachedImage(
                    imageUrl: user!.photo!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : SvgPicture.asset(AppIcons.profile, width: 50, height: 50),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${user?.firstName} ${user?.lastName}",
              style: AppTextStyles.black18500,
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => getIt<EditProfileCubit>(),
                      child: EditProfileScreen(profileUser: user!),
                    ),
                  ),
                );

                if (!context.mounted) return;

                if (result == true) {
                  context.read<ProfileCubit>().doEvent(GetProfileDataEvent());
                }
              },
              child: Icon(Icons.edit, size: 20, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(user?.email ?? '', style: AppTextStyles.gray18500),
      ],
    );
  }
}
