import 'package:doctor_appointment/core/themes/colors_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static TextStyle font24Black700W = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle font32Blue700W = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: ColorsManager.primary_100,
  );

  static TextStyle font12Body400W = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.textBody,
  );
  static TextStyle font16White700W = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: ColorsManager.white,
    height: 1.4,
  );
}
