import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressItemCard extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isDeleting;

  const AddressItemCard({
    super.key,
    required this.address,
    required this.onDelete,
    required this.onEdit,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.white60, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: SvgPicture.asset(
              AppIcons.location,
              colorFilter: const ColorFilter.mode(
                AppColors.black,
                BlendMode.srcIn,
              ),
              width: 20.r,
              height: 20.r,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.city, style: AppTextStyles.black14600),
                SizedBox(height: 4.h),
                Text(
                  "${address.area}, ${address.street}",
                  style: AppTextStyles.gray12400,
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isDeleting
                  ? SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      onPressed: onDelete,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: Image.asset(
                        AppIcons.delete,
                        color: AppColors.error,
                        width: 22.r,
                        height: 22.r,
                      ),
                    ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: onEdit,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.black40,
                  size: 22.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
