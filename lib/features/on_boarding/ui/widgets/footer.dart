import 'package:doctor_appointment/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: 'Get Started',
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
    );
  }
}
