import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController controller;
  final Function(int)? onTap;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        onTap: onTap,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelPadding: EdgeInsets.only(right: 24.w),
        tabs: List.generate(tabs.length, (index) {
          final isSelected = controller.index == index;
          return AnimatedBuilder(
            animation: controller.animation!,
            builder: (context, child) {
              final selected = controller.index == index;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: selected ? AppColors.primary : AppColors.white70,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 80.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.white70,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
