import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/widgets/custom_snack_bar.dart';
import 'package:flowers_app/features/track_order/domain/entities/tracked_order_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// كارت الرايدر (delivery hero) مع اسمه وأزرار الاتصال والواتساب.
class RiderContactCard extends StatelessWidget {
  final TrackedOrderEntity order;

  const RiderContactCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final hasRider = order.hasRider;

    return Row(
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.gray10,
          child: Icon(Icons.person, color: AppColors.gray, size: 26.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasRider ? order.riderName! : AppStrings.noRiderYet.tr(),
                style: AppTextStyles.black16600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (hasRider) ...[
                SizedBox(height: 2.h),
                Text(
                  AppStrings.deliveryHero.tr(),
                  style: AppTextStyles.gray12400,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (order.hasRiderPhone) ...[
          _ContactButton(
            icon: Icons.phone,
            onTap: () => _launch('tel:${order.riderPhone}'),
          ),
          SizedBox(width: 12.w),
          _ContactButton(
            icon: Icons.chat,
            onTap: () => _launch('https://wa.me/${_waNumber(order.riderPhone!)}'),
          ),
        ],
      ],
    );
  }

  /// واتساب بيحتاج الرقم الدولي بدون + وبدون رموز.
  String _waNumber(String phone) => phone.replaceAll(RegExp(r'[^0-9]'), '');

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    final ok = await canLaunchUrl(uri) &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      CustomSnackBar.showErrorMessage(AppStrings.couldNotOpenApp.tr());
    }
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ContactButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        width: 40.r,
        height: 40.r,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 20.r),
      ),
    );
  }
}
