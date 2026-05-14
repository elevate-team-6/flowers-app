import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_colors.dart';

class MainNavBarItem extends BottomNavigationBarItem {
  MainNavBarItem({required String iconPath, required String label})
    : super(
        icon: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(
            AppColors.black30,
            BlendMode.srcIn,
          ),
        ),
        activeIcon: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        label: label,
      );
}
