import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctor_appointment/core/utils/app_colors.dart';

abstract class AppStyles {
  static TextStyle styleSemiBold22 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    color: Color(0xff1E252D),
    fontFamily: 'Inter',
  );

  static TextStyle styleRegular14 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xff808E92),
    fontFamily: 'Inter',
  );

  static TextStyle styleSemiBold16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: Colors.white,
  );

  static TextStyle styleSemiBold24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: Color(0xff1E252D),
  );
  static TextStyle styleMedium14 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'Inter',
    color: Color(0xff1E252D),
  );
  static TextStyle styleRegular12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
    color: Color(0xff1E252D),
  );
}

/// Modern text-style tokens used across the Home feature widgets.
abstract class AppTextStyles {
  // ── Display ──
  static TextStyle get displayMedium => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        fontFamily: 'Inter',
      );

  // ── Headings ──
  static TextStyle get headingLarge => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        fontFamily: 'Inter',
      );

  static TextStyle get headingMedium => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontFamily: 'Inter',
      );

  static TextStyle get headingSmall => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontFamily: 'Inter',
      );

  // ── Body ──
  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        fontFamily: 'Inter',
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        fontFamily: 'Inter',
      );

  // ── Labels ──
  static TextStyle get labelLarge => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        fontFamily: 'Inter',
      );

  static TextStyle get labelMedium => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        fontFamily: 'Inter',
      );

  // ── Section ──
  static TextStyle get sectionTitle => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        fontFamily: 'Inter',
      );

  // ── Banner / Greeting ──
  static TextStyle get greetingTitle => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontFamily: 'Inter',
        height: 1.3,
      );
}
