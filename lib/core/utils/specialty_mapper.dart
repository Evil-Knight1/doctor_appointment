import 'package:flutter/material.dart';
import 'package:doctor_appointment/core/utils/app_colors.dart';

class SpecialtyTheme {
  final IconData icon;
  final Color color;
  final Color bgColor;

  const SpecialtyTheme({
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

class SpecialtyMapper {
  static SpecialtyTheme getThemeForSpecialty(String? name) {
    final lowerName = (name ?? '').toLowerCase();

    if (lowerName.contains('cardio')) {
      return const SpecialtyTheme(
        icon: Icons.favorite_rounded,
        color: Color(0xFFE11D48),
        bgColor: Color(0xFFFFF1F2),
      );
    }
    if (lowerName.contains('neuro')) {
      return const SpecialtyTheme(
        icon: Icons.psychology_rounded,
        color: Color(0xFF7C3AED),
        bgColor: Color(0xFFF5F3FF),
      );
    }
    if (lowerName.contains('dent')) {
      return const SpecialtyTheme(
        icon: Icons.health_and_safety_rounded,
        color: Color(0xFF059669),
        bgColor: Color(0xFFECFDF5),
      );
    }
    if (lowerName.contains('pedia')) {
      return const SpecialtyTheme(
        icon: Icons.child_care_rounded,
        color: Color(0xFFD97706),
        bgColor: Color(0xFFFFFBEB),
      );
    }
    if (lowerName.contains('derm')) {
      return const SpecialtyTheme(
        icon: Icons.face_rounded,
        color: Color(0xFFDB2777),
        bgColor: Color(0xFFFDF2F8),
      );
    }
    if (lowerName.contains('ortho')) {
      return const SpecialtyTheme(
        icon: Icons.medical_services_rounded,
        color: Color(0xFF2563EB),
        bgColor: Color(0xFFEFF6FF),
      );
    }
    if (lowerName.contains('optomet')) {
      return const SpecialtyTheme(
        icon: Icons.visibility_outlined,
        color: Color(0xFF2563EB),
        bgColor: Color(0xFFEFF6FF),
      );
    }
    if (lowerName.contains('pulmon')) {
      return const SpecialtyTheme(
        icon: Icons.air_outlined,
        color: Color(0xFF0891B2),
        bgColor: Color(0xFFECFEFF),
      );
    }
    if (lowerName.contains('ent')) {
      return const SpecialtyTheme(
        icon: Icons.hearing_outlined,
        color: Color(0xFF4F46E5),
        bgColor: Color(0xFFEEF2FF),
      );
    }

    // Default
    return SpecialtyTheme(
      icon: Icons.medical_services_outlined,
      color: AppColors.primary,
      bgColor: AppColors.primaryLight,
    );
  }
}
