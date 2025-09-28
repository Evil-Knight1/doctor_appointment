import 'package:doctor_appointment/core/helpers/assets_helper.dart';
import 'package:doctor_appointment/core/helpers/colors_helper.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AssetsHelper.logo,
          scale: .2,
          opacity: const AlwaysStoppedAnimation(0.1),
        ),
        Center(child: Image.asset(AssetsHelper.doctorImage, scale: .5)),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withAlpha(0),
                  Colors.white.withAlpha(100),
                  Colors.white.withAlpha(150),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 18,
              children: [
                Text(
                  'Best Doctor\nAppointment App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorsHelper.primary_100,
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  ),
                ),
                Text(
                  'Manage and schedule all of your medical appointments easily with Docdoc to get a new experience.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorsHelper.textSecondary,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
