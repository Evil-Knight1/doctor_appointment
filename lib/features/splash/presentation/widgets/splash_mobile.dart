import 'package:doctor_appointment/core/utils/app_images.dart';
import 'package:doctor_appointment/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashMobile extends StatelessWidget {
  const SplashMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        children: [
          const Spacer(flex: 3),
          Expanded(
            flex: 4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 72.w,
                    child: Image.asset(Assets.imagesLogo, fit: BoxFit.contain),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'MedLink',
                    style: context.styleBold24.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SpinKitFadingCircle(color: colorScheme.primary, size: 50),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
