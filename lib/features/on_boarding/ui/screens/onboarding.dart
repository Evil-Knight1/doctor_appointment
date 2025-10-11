import 'package:doctor_appointment/core/helpers/extensions.dart';
import 'package:doctor_appointment/core/routes/routes.dart';
import 'package:doctor_appointment/core/themes/styles.dart';
import 'package:doctor_appointment/core/widgets/primary_button.dart';
import 'package:doctor_appointment/features/on_boarding/ui/widgets/doc_body.dart';
import 'package:doctor_appointment/features/on_boarding/ui/widgets/doc_logo_and_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                DocLogoAndName(),
                SizedBox(height: 30.h),
                DocBody(),
                SizedBox(height: 18.h),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 30.w),
                  child: Column(
                    children: [
                      Text(
                        'Manage and schedule all of your medical appointments easily with Docdoc to get a new experience.',
                        textAlign: TextAlign.center,
                        style: TextStyles.font12BodyRegular.copyWith(
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      PrimaryButton(
                        text: 'Get Started',
                        onPressed: () => {
                          context.pushNamedReplacement(Routes.login),
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
