import 'package:doctor_appointment/core/routes/app_router.dart';
import 'package:doctor_appointment/core/routes/routes.dart';
import 'package:doctor_appointment/core/themes/colors_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorAppointment extends StatelessWidget {
  const DoctorAppointment({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        onGenerateRoute: appRouter.generateRoute,
        initialRoute: Routes.onBoarding,
        debugShowCheckedModeBanner: false,
        title: 'Doctor Appointment',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF247CFF, {
            50: ColorsManager.primary_100,
            100: ColorsManager.primary_100,
            200: ColorsManager.primary_100,
            300: ColorsManager.primary_100,
            400: ColorsManager.primary_100,
            500: ColorsManager.primary_100,
            600: ColorsManager.primary_100,
            700: ColorsManager.primary_100,
            800: ColorsManager.primary_100,
            900: ColorsManager.primary_100,
          }),
        ),
      ),
    );
  }
}
