import 'package:doctor_appointment/core/theme/app_theme_extension.dart';

import 'package:doctor_appointment/core/utils/go_router.dart';
import 'package:doctor_appointment/features/on_boarding_view/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_appointment/core/services/shared_preferences_helper.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                // Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/docdoc_logo.svg',
                      width: 40.w,
                      colorFilter: ColorFilter.mode(
                        colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(
                      'MedLink',
                      style: context.styleBold32.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                // Doctor Image with Gradient
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/onboarding_doctors.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 200.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Theme.of(context).scaffoldBackgroundColor,
                                Theme.of(
                                  context,
                                ).scaffoldBackgroundColor.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Title
                Text(
                  'Best Doctor\nAppointment App',
                  textAlign: TextAlign.center,
                  style: context.styleBold32.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 18.h),
                // Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    'Manage and schedule all of your medical appointments easily with Docdoc to get a new experience.',
                    textAlign: TextAlign.center,
                    style: context.styleRegular12.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(height: 35.h),
                // Get Started Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: CustomButton(
                    height: 52.h,
                    width: double.infinity,
                    text: 'Get Started',
                    onPressed: () async {
                      await SharedPreferencesHelper.saveHasSeenOnboarding(true);
                      if (context.mounted) {
                        context.go(AppRouter.kUserSelectionView);
                      }
                    },
                    buttonColor: colorScheme.primary,
                    textStyle: context.styleSemiBold16.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                    circleSize: 16.r,
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
