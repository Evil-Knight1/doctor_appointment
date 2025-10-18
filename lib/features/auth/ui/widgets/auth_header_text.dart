import 'package:doctor_appointment/core/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeaderText extends StatelessWidget {
  const AuthHeaderText({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.font24BlueBold.copyWith(
              height: 1.5,
              letterSpacing: -.2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyles.font14BodyRegular.copyWith(
              height: 1.8,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );
  }
}
