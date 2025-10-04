import 'package:doctor_appointment/core/helpers/assets_helper.dart';
import 'package:doctor_appointment/core/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DocBody extends StatelessWidget {
  const DocBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: Alignment.topCenter,
      children: [
        SvgPicture.asset(AssetsHelper.logoScaledWithLowOpacity),
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withAlpha(0)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.14, 0.4],
            ),
          ),
          child: Image.asset(AssetsHelper.doctorImage),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.h),
            child: Text(
              'Best Doctor\nAppointment App',
              textAlign: TextAlign.center,
              style: TextStyles.font32Blue700W.copyWith(height: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
