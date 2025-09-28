import 'package:doctor_appointment/features/on_boarding/ui/widgets/body.dart';
import 'package:doctor_appointment/features/on_boarding/ui/widgets/footer.dart';
import 'package:doctor_appointment/features/on_boarding/ui/widgets/header.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 30,
          children: [const SizedBox(height: 20), Header(), Body(), Footer()],
        ),
      ),
    );
  }
}
