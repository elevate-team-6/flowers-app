import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController controller;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.white70,
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 2,
      labelStyle: AppTextStyles.black16400,
      unselectedLabelStyle: AppTextStyles.black16400,
      dividerColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      tabs: tabs.map((tab) => Tab(text: tab)).toList(),
    );
  }
}
