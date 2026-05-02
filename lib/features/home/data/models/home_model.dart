import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Speciality model
// ─────────────────────────────────────────────────────────────────────────────
class SpecialityModel {
  const SpecialityModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final String name;
  final IconData icon;
  final Color color;
  final Color bgColor;
}

// ─────────────────────────────────────────────────────────────────────────────
// Doctor model used by the Home feature (static/demo data)
// ─────────────────────────────────────────────────────────────────────────────
class DoctorModel {
  const DoctorModel({
    required this.name,
    required this.speciality,
    required this.hospital,
    required this.rating,
    required this.reviewCount,
    this.isAvailable = true,
  });

  final String name;
  final String speciality;
  final String hospital;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification item model
// ─────────────────────────────────────────────────────────────────────────────
class NotificationItemModel {
  const NotificationItemModel({
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.isRead = false,
    this.isToday = true,
  });

  final String title;
  final String message;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final bool isRead;
  final bool isToday;
}

// ─────────────────────────────────────────────────────────────────────────────
// Static sample data for the Home screens
// ─────────────────────────────────────────────────────────────────────────────
class HomeStaticData {
  HomeStaticData._();

  static const List<SpecialityModel> specialities = [
    SpecialityModel(
      name: 'General',
      icon: Icons.local_hospital_outlined,
      color: Color(0xFF2563EB),
      bgColor: Color(0xFFEFF6FF),
    ),
    SpecialityModel(
      name: 'Neurologic',
      icon: Icons.psychology_outlined,
      color: Color(0xFF7C3AED),
      bgColor: Color(0xFFF5F3FF),
    ),
    SpecialityModel(
      name: 'Pediatric',
      icon: Icons.child_care_outlined,
      color: Color(0xFFEC4899),
      bgColor: Color(0xFFFDF2F8),
    ),
    SpecialityModel(
      name: 'Radiology',
      icon: Icons.radio_button_checked_outlined,
      color: Color(0xFF059669),
      bgColor: Color(0xFFECFDF5),
    ),
  ];

  static const List<DoctorModel> recommendedDoctors = [
    DoctorModel(
      name: 'Dr. Olivia Turner, M.D.',
      speciality: 'General',
      hospital: 'Cairo Hospital',
      rating: 4.9,
      reviewCount: 5380,
      isAvailable: true,
    ),
    DoctorModel(
      name: 'Dr. Alexander Bennett',
      speciality: 'Neurologic',
      hospital: 'Nile Medical Center',
      rating: 4.8,
      reviewCount: 4220,
      isAvailable: true,
    ),
    DoctorModel(
      name: 'Dr. Sophia Martinez',
      speciality: 'Pediatric',
      hospital: 'Al Salam Hospital',
      rating: 4.7,
      reviewCount: 3150,
      isAvailable: false,
    ),
    DoctorModel(
      name: 'Dr. Michael Chen, Ph.D.',
      speciality: 'Radiology',
      hospital: 'Ain Shams Clinic',
      rating: 4.9,
      reviewCount: 6210,
      isAvailable: true,
    ),
  ];
}
