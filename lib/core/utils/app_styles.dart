import 'package:flutter/material.dart';

abstract class AppStyles {
  static TextStyle styleBold32(BuildContext context) => Theme.of(context).textTheme.displayLarge!;
  static TextStyle styleBold24(BuildContext context) => Theme.of(context).textTheme.displaySmall!;
  static TextStyle styleBold20(BuildContext context) => Theme.of(context).textTheme.headlineSmall!;
  static TextStyle styleSemiBold24(BuildContext context) => Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w600);
  static TextStyle styleSemiBold22(BuildContext context) => Theme.of(context).textTheme.headlineMedium!;
  static TextStyle styleSemiBold18(BuildContext context) => Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600);
  static TextStyle styleSemiBold16(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
  static TextStyle styleMedium14(BuildContext context) => Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500);
  static TextStyle styleRegular14(BuildContext context) => Theme.of(context).textTheme.bodyMedium!;
  static TextStyle styleMedium12(BuildContext context) => Theme.of(context).textTheme.labelMedium!;
  static TextStyle styleRegular12(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
  static TextStyle styleRegular10(BuildContext context) => Theme.of(context).textTheme.labelSmall!;
  static TextStyle styleBold18(BuildContext context) => Theme.of(context).textTheme.titleLarge!;
  static TextStyle styleBold16(BuildContext context) => Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold);
  static TextStyle styleBold14(BuildContext context) => Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold);
  static TextStyle styleSemiBold20(BuildContext context) => Theme.of(context).textTheme.headlineSmall!;
  static TextStyle styleSemiBold14(BuildContext context) => Theme.of(context).textTheme.titleSmall!;
}

abstract class AppTextStyles {
  static TextStyle displayMedium(BuildContext context) => Theme.of(context).textTheme.headlineSmall!;
  static TextStyle headingLarge(BuildContext context) => Theme.of(context).textTheme.titleLarge!;
  static TextStyle headingMedium(BuildContext context) => Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15);
  static TextStyle headingSmall(BuildContext context) => Theme.of(context).textTheme.titleSmall!;
  static TextStyle bodyMedium(BuildContext context) => Theme.of(context).textTheme.bodyMedium!;
  static TextStyle bodySmall(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
  static TextStyle labelLarge(BuildContext context) => Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 13);
  static TextStyle labelMedium(BuildContext context) => Theme.of(context).textTheme.labelMedium!;
  static TextStyle sectionTitle(BuildContext context) => Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold);
  static TextStyle greetingTitle(BuildContext context) => Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white, height: 1.3);
}


