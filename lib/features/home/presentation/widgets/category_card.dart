import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.imageUrl,
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightPink,
              borderRadius: BorderRadius.circular(20),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.local_florist, color: AppColors.primary),
            ),
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
