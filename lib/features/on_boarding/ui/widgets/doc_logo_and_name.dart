import 'package:doctor_appointment/core/helpers/assets_helper.dart';
import 'package:doctor_appointment/core/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DocLogoAndName extends StatelessWidget {
  const DocLogoAndName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AssetsHelper.logo, height: 38.h, width: 38.w),
        SizedBox(width: 10.w),
        Text(AssetsHelper.appName, style: TextStyles.font24BlackBold),
      ],
    );
  }
}
