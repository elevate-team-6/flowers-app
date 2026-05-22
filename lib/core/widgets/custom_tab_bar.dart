import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController controller;
  final Function(int index)? onTabSelected;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      onTap: onTabSelected,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicator: const BoxDecoration(), // Hide default indicator
      dividerColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      labelPadding: EdgeInsets.only(right: 24.w), // Space between tabs
      splashFactory: NoSplash.splashFactory,
      tabs: List.generate(tabs.length, (index) {
        return AnimatedBuilder(
          animation: controller.animation!,
          builder: (context, child) {
            final animationValue = controller.animation!.value;
            final double distance = (animationValue - index).abs();
            final double selectionFraction = (1 - distance).clamp(0.0, 1.0);

            final color = Color.lerp(
              AppColors.gray.withValues(alpha: 0.7), // Unselected gray
              AppColors.primary, // Selected pink
              selectionFraction,
            );

            return Tab(
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        tabs[index],
                        style: AppTextStyles.black16400.copyWith(color: color),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
