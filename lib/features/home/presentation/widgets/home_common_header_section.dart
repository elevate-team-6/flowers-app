import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';

class HomeCommonHeaderSection extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const HomeCommonHeaderSection({
    super.key,
    required this.title,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              AppStrings.viewAll,
              style: TextStyle(
                decoration: TextDecoration.underline,

                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
