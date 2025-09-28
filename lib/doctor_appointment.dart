import 'package:doctor_appointment/core/routes/app_router.dart';
import 'package:doctor_appointment/core/routes/routes.dart';
import 'package:flutter/material.dart';

class DoctorAppointment extends StatelessWidget {
  const DoctorAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: Routes.onBoarding,
      debugShowCheckedModeBanner: false,
      title: 'Doctor Appointment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}
