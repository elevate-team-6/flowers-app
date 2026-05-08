import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class OccasionCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback? onTap;

  const OccasionCard({
    super.key,
    required this.imageUrl,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: Image.network(
                imageUrl,
                width: 140,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 140,
                  height: 150,
                  color: AppColors.white60,
                  child: const Icon(
                    Icons.celebration,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
