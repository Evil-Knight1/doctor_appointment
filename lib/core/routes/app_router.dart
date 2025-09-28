import 'package:doctor_appointment/core/routes/routes.dart';
import 'package:doctor_appointment/features/on_boarding/ui/screens/onboarding.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Splash Screen'))),
        );
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Login Screen'))),
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Register Screen'))),
        );
      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Forgot Password Screen')),
          ),
        );
      case Routes.main:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Main Screen'))),
        );
      case Routes.doctorDetails:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Doctor Details Screen')),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('unknown Screen'))),
        );
    }
  }
}
