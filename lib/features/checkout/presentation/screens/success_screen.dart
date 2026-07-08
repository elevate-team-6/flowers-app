import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessScreen extends StatelessWidget {
  /// id الأوردر عشان زر "Track order" يفتح شاشة التتبع الصح.
  /// بيبقى null في مسار الدفع بالكارت (مفيش order id جاهز من الـ session).
  final String? orderId;

  const SuccessScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.trackOrder.tr()),
        leading: IconButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.mainLayout),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.h, vertical: 70.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppIcons.success),
            SizedBox(height: 30.h),

            Text(AppStrings.trackOrderSuccess, style: AppTextStyles.black24600),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {
                if (orderId != null && orderId!.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.orderTracking,
                    arguments: orderId,
                  );
                } else {
                  Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
                }
              },
              child: Text(AppStrings.trackOrder.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
