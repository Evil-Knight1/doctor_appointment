import 'package:flutter/material.dart';

class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color? success;
  final Color? warning;
  final Color? appointmentPending;
  final Color? doctorOnline;
  final Color? chatBubbleMine;
  final Color? chatBubbleOthers;
  final Color? chatBubbleMineGradientStart;
  final Color? chatBubbleMineGradientEnd;
  final Color? rating;
  final Color? error;
  final Color? offline;

  const AppCustomColors({
    required this.success,
    required this.warning,
    required this.appointmentPending,
    required this.doctorOnline,
    required this.chatBubbleMine,
    required this.chatBubbleOthers,
    required this.chatBubbleMineGradientStart,
    required this.chatBubbleMineGradientEnd,
    required this.rating,
    required this.error,
    this.offline,
  });

  @override
  AppCustomColors copyWith({
    Color? success,
    Color? warning,
    Color? appointmentPending,
    Color? doctorOnline,
    Color? chatBubbleMine,
    Color? chatBubbleOthers,
    Color? chatBubbleMineGradientStart,
    Color? chatBubbleMineGradientEnd,
    Color? rating,
    Color? error,
    Color? offline,
  }) {
    return AppCustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      appointmentPending: appointmentPending ?? this.appointmentPending,
      doctorOnline: doctorOnline ?? this.doctorOnline,
      chatBubbleMine: chatBubbleMine ?? this.chatBubbleMine,
      chatBubbleOthers: chatBubbleOthers ?? this.chatBubbleOthers,
      chatBubbleMineGradientStart:
          chatBubbleMineGradientStart ?? this.chatBubbleMineGradientStart,
      chatBubbleMineGradientEnd:
          chatBubbleMineGradientEnd ?? this.chatBubbleMineGradientEnd,
      rating: rating ?? this.rating,
      error: error ?? this.error,
      offline: offline ?? this.offline,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      appointmentPending:
          Color.lerp(appointmentPending, other.appointmentPending, t),
      doctorOnline: Color.lerp(doctorOnline, other.doctorOnline, t),
      chatBubbleMine: Color.lerp(chatBubbleMine, other.chatBubbleMine, t),
      chatBubbleOthers: Color.lerp(chatBubbleOthers, other.chatBubbleOthers, t),
      chatBubbleMineGradientStart: Color.lerp(
          chatBubbleMineGradientStart, other.chatBubbleMineGradientStart, t),
      chatBubbleMineGradientEnd: Color.lerp(
          chatBubbleMineGradientEnd, other.chatBubbleMineGradientEnd, t),
      rating: Color.lerp(rating, other.rating, t),
      error: Color.lerp(error, other.error, t),
      offline: Color.lerp(offline, other.offline, t),
    );
  }
}

extension CustomTheme on BuildContext {
  AppCustomColors get customColors =>
      Theme.of(this).extension<AppCustomColors>()!;

  TextTheme get textTheme => Theme.of(this).textTheme;

  // Standard Material 3 Text Styles
  TextStyle get displayLarge => textTheme.displayLarge!;
  TextStyle get displayMedium => textTheme.displayMedium!;
  TextStyle get displaySmall => textTheme.displaySmall!;
  TextStyle get headlineLarge => textTheme.headlineLarge!;
  TextStyle get headlineMedium => textTheme.headlineMedium!;
  TextStyle get headlineSmall => textTheme.headlineSmall!;
  TextStyle get titleLarge => textTheme.titleLarge!;
  TextStyle get titleMedium => textTheme.titleMedium!;
  TextStyle get titleSmall => textTheme.titleSmall!;
  TextStyle get bodyLarge => textTheme.bodyLarge!;
  TextStyle get bodyMedium => textTheme.bodyMedium!;
  TextStyle get bodySmall => textTheme.bodySmall!;
  TextStyle get labelLarge => textTheme.labelLarge!;
  TextStyle get labelMedium => textTheme.labelMedium!;
  TextStyle get labelSmall => textTheme.labelSmall!;

  // Legacy & Specific App Styles (Aliases)
  TextStyle get styleBold32 => textTheme.displayLarge!;
  TextStyle get styleBold24 => textTheme.displaySmall!;
  TextStyle get styleBold20 => textTheme.headlineSmall!;
  TextStyle get styleSemiBold24 =>
      textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w600);
  TextStyle get styleSemiBold22 => textTheme.headlineMedium!;
  TextStyle get styleSemiBold20 => textTheme.headlineSmall!;
  TextStyle get styleSemiBold18 =>
      textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600);
  TextStyle get styleSemiBold16 => textTheme.titleMedium!;
  TextStyle get styleSemiBold14 => textTheme.titleSmall!;
  TextStyle get styleBold18 => textTheme.titleLarge!;
  TextStyle get styleBold16 =>
      textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold);
  TextStyle get styleBold14 =>
      textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold);
  TextStyle get styleMedium14 =>
      textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500);
  TextStyle get styleMedium12 => textTheme.labelMedium!;
  TextStyle get styleRegular14 => textTheme.bodyMedium!;
  TextStyle get styleRegular12 => textTheme.bodySmall!;
  TextStyle get styleRegular10 => textTheme.labelSmall!;

  // AppTextStyles & Semantic Aliases
  TextStyle get headingLarge => textTheme.titleLarge!;
  TextStyle get headingMedium => textTheme.titleSmall!.copyWith(fontSize: 15);
  TextStyle get headingSmall => textTheme.titleSmall!;
  TextStyle get sectionTitle =>
      textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold);
  TextStyle get greetingTitle =>
      textTheme.titleLarge!.copyWith(color: Colors.white, height: 1.3);
}
