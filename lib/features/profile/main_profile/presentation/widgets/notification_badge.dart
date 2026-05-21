import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationBadge extends StatelessWidget {
  final String count;
  final VoidCallback onTap;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Badge(
        label: Text(
          count,
          style: AppTextStyles.white16500.copyWith(fontSize: 11),
        ),
        backgroundColor: AppColors.red,
        largeSize: 18,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SvgPicture.asset(AppIcons.bell, width: 28, height: 28),
      ),
    );
  }
}
