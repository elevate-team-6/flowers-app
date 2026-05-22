import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/app_routes.dart';

class ProfileHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String? image;

  const ProfileHeader({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: image != null ? NetworkImage(image!) : null,
          backgroundColor: AppColors.white60,
          child: image == null
              ? SvgPicture.asset(AppIcons.profile, width: 50, height: 50)
              : null,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$firstName $lastName", style: AppTextStyles.black18500),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
              child: Icon(Icons.edit, size: 20, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(email, style: AppTextStyles.gray18500),
      ],
    );
  }
}
