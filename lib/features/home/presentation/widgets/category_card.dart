import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.lightPink,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 28, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
