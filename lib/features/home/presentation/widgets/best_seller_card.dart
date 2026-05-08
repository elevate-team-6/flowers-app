import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BestSellerCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final VoidCallback? onTap;

  const BestSellerCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
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
                    Icons.local_florist,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              price,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
