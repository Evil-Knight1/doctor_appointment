import 'package:doctor_appointment/core/helpers/assets_helper.dart';
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
          bottom: 20,
          left: 0,
          right: 0,
          child: Text(
            AssetsHelper.appName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
