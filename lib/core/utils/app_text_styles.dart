import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  // Safe ScreenUtil helper to prevent fontSize <= 0 errors
  static double _sp(num size) {
    try {
      // If ScreenUtil is not initialized or returns invalid value, fallback to original size
      final sp = size.sp;
      return sp > 0 ? sp : size.toDouble();
    } catch (_) {
      return size.toDouble();
    }
  }

  // Black Styles
  static TextStyle get black20500 => GoogleFonts.inter(
    fontSize: _sp(20),
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static TextStyle get black13400 => GoogleFonts.inter(
    fontSize: _sp(13),
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static TextStyle get black16400 => GoogleFonts.inter(
    fontSize: _sp(16),
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static TextStyle get black12400 => GoogleFonts.inter(
    fontSize: _sp(12),
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static TextStyle get black18500 => GoogleFonts.inter(
    fontSize: _sp(18),
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  // Gray Styles
  static TextStyle get gray14400 => GoogleFonts.inter(
    fontSize: _sp(14),
    fontWeight: FontWeight.w400,
    color: AppColors.black30,
  );

  static TextStyle get gray12400 => GoogleFonts.inter(
    fontSize: _sp(12),
    fontWeight: FontWeight.w400,
    color: AppColors.gray,
  );

  // White Styles
  static TextStyle get white16500 => GoogleFonts.inter(
    fontSize: _sp(16),
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  // primary color styles

  static TextStyle get primary16400 => GoogleFonts.inter(
    fontSize: _sp(16),
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
}
