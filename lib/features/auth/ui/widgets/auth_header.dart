import 'package:doctor_appointment/core/themes/colors_manger.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 90, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              height: 1.5,
              fontWeight: FontWeight.bold,
              color: ColorsManager.primary_100,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              height: 1.8,
              color: ColorsManager.textBody,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );
  }
}
