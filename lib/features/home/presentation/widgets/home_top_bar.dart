import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Row(
            children: [
              Icon(Icons.local_florist, color: AppColors.primary, size: 22),
              const SizedBox(width: 4),
              Text(
                AppStrings.flowery.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomSearchField(
              readOnly: true,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.search);
              },
            ),
          ),
        ],
      ),
    );
  }
}
