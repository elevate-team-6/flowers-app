import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/categories/presentation/widgets/filter_option_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? initialSort;
  const FilterBottomSheet({super.key, this.initialSort});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSort ?? AppStrings.highestPrice;
  }

  final List<String> _sortOptions = [
    AppStrings.lowestPrice,
    AppStrings.highestPrice,
    AppStrings.newText,
    AppStrings.oldText,
    AppStrings.discountText,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              height: 4.h,
              width: 48.w,
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Title
          Text(
            AppStrings.sortBy,
            style: AppTextStyles.primary20700,
          ),
          SizedBox(height: 16.h),

          // Filter options
          ..._sortOptions.map(
            (option) => FilterOptionItem(
              title: option,
              isSelected: _selectedSort == option,
              onTap: () => setState(() => _selectedSort = option),
            ),
          ),

          SizedBox(height: 24.h),

          // Filter Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, _selectedSort);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
                elevation: 0,
              ),
              icon: SvgPicture.asset(
                AppIcons.filtration,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(
                AppStrings.filter,
                style: AppTextStyles.white16600,
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
