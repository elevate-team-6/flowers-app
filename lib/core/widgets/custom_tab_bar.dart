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
    final tabBarTheme = Theme.of(context).tabBarTheme;

    return SizedBox(
      height: 45.h,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        onTap: onTap,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        indicatorColor: Colors.transparent,
        labelPadding: EdgeInsets.only(right: 24.w),
        tabs: List.generate(tabs.length, (index) {
          return AnimatedBuilder(
            animation: controller.animation!,
            builder: (context, child) {
              final selected = controller.index == index;
              return IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: tabBarTheme.labelStyle?.copyWith(
                        color: selected
                            ? tabBarTheme.labelColor
                            : tabBarTheme.unselectedLabelColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.white70,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
