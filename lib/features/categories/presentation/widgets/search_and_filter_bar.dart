import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchAndFilterBar extends StatelessWidget {
  final VoidCallback onFilterTap;

  const SearchAndFilterBar({
    super.key,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomSearchField(
            readOnly: true,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.search);
            },
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
