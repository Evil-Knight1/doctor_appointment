import 'package:doctor_appointment/core/themes/colors_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static TextStyle font24BlackBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle font24BlueBold = TextStyle(
    fontSize: 24.sp,
    color: ColorsManager.primary_100,
    fontWeight: FontWeight.bold,
  );

  static TextStyle font32BlueBold = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManager.primary_100,
  );

  static TextStyle font12BodyRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManager.textBody,
  );
  static TextStyle font14BodyRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManager.textBody,
  );
  static TextStyle font16WhiteBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManager.white,
    height: 1.4,
  );
}
