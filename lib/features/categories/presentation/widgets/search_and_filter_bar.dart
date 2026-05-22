import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchAndFilterBar extends StatelessWidget {
  final VoidCallback onFilterTap;
  final Function(String)? onSearchChanged;

  const SearchAndFilterBar({
    super.key,
    required this.onFilterTap,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.white60, width: 1),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: AppStrings.search.tr(),
                hintStyle: AppTextStyles.gray14400,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    AppIcons.search,
                    colorFilter: ColorFilter.mode(
                      AppColors.gray,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            height: 48.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.white60, width: 1),
            ),
            child: Center(
              child: SvgPicture.asset(AppIcons.sort, width: 24.w, height: 24.h),
            ),
          ),
        ),
      ],
    );
  }
}
