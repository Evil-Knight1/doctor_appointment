import 'package:doctor_appointment/core/theme/app_theme_extension.dart';
import 'package:doctor_appointment/core/utils/app_colors.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final colorScheme = SeedColorScheme.fromSeeds(
      brightness: brightness,
      primaryKey: AppColors.primary,
      secondaryKey: AppColors.secondary,
      tertiaryKey: AppColors.accent,
      surfaceTint: isLight ? AppColors.primary : Colors.transparent,
      tones: isLight ? FlexTones.soft(brightness) : FlexTones.vivid(brightness),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isLight ? AppColors.bg : AppColors.darkBg,
      cardColor: isLight ? AppColors.white : AppColors.darkSurface,
      dividerColor: isLight ? AppColors.gray200 : AppColors.darkBorder,
      hintColor: isLight ? AppColors.textSecondary : AppColors.darkTextSecondary,
      shadowColor: isLight ? Colors.black.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.2),
      canvasColor: isLight ? AppColors.bg : AppColors.darkBg,
      fontFamily: 'Inter',
      textTheme: _textTheme(brightness),
      appBarTheme: AppBarTheme(
        backgroundColor: isLight ? AppColors.bg : AppColors.darkBg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: _textTheme(brightness).titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLight ? AppColors.textPrimary : AppColors.darkTextPrimary,
            ),
        iconTheme: IconThemeData(
          color: isLight ? AppColors.textPrimary : AppColors.darkTextPrimary,
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(brightness),
      iconTheme: IconThemeData(
        color: isLight ? AppColors.textSecondary : AppColors.darkTextSecondary,
      ),
      extensions: [
        AppCustomColors(
          success: AppColors.success,
          warning: AppColors.warning,
          appointmentPending: AppColors.pending,
          doctorOnline: AppColors.online,
          chatBubbleMine: isLight ? AppColors.chatMineLight : AppColors.chatMineDark,
          chatBubbleOthers: isLight ? AppColors.chatOthersLight : AppColors.chatOthersDark,
          chatBubbleMineGradientStart: AppColors.headerGradientStart,
          chatBubbleMineGradientEnd: AppColors.headerGradientEnd,
          rating: AppColors.star,
          error: AppColors.error,
        ),
      ],
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final primaryColor = isLight ? AppColors.textPrimary : AppColors.darkTextPrimary;
    final secondaryColor = isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final lightColor = isLight ? AppColors.textLight : AppColors.darkTextLight;

    return TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: primaryColor),
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
      bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primaryColor),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: secondaryColor),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: secondaryColor),
      labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: primaryColor),
      labelMedium: TextStyle(fontSize: 11, fontWeight: FontWeight.normal, color: secondaryColor),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: lightColor),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final fillColor = isDark ? AppColors.darkSurface : AppColors.gray100;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.gray200;
    final hintColor = isDark ? AppColors.darkTextSecondary : AppColors.textLight;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hintStyle: TextStyle(color: hintColor, fontSize: 14),
      labelStyle: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _buildBorder(borderColor),
      enabledBorder: _buildBorder(borderColor),
      focusedBorder: _buildBorder(AppColors.primary, width: 1.5),
      errorBorder: _buildBorder(AppColors.accent),
      focusedErrorBorder: _buildBorder(AppColors.accent, width: 1.5),
    );
  }

  static OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
