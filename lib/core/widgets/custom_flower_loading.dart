import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomFlowerLoading extends StatelessWidget {
  const CustomFlowerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // يمنع إغلاق الشاشة بالرجوع (Back Button) أثناء التحميل
      child: Material(
        color: Colors.black.withValues(
          alpha: 0.5,
        ), // لون رمادي شفاف يغطي الشاشة
        child: Center(
          child: Lottie.asset(
            AppLottie.flowerLoading,
            width: 150, // حجم الوردة في منتصف الشاشة
            height: 150,
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      ),
    );
  }
}
