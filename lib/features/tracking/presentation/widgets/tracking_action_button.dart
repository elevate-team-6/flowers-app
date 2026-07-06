

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackingActionButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const TrackingActionButton({super.key, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(shape: BoxShape.circle),
        padding: EdgeInsets.all(8.w),
        child: Image.asset(
          iconPath,
          width: 18.w,
          height: 18.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
