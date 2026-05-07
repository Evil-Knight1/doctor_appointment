import 'package:doctor_appointment/features/doctors/data/models/doctor_api_model.dart';
import 'package:doctor_appointment/features/doctors/domain/entities/doctor.dart';
import 'package:doctor_appointment/core/utils/specialty_mapper.dart';
import 'package:flutter/material.dart';

class HomeDoctorModel {
  final Doctor doctor;
  final bool isFavorite;

  const HomeDoctorModel({required this.doctor, this.isFavorite = false});

  factory HomeDoctorModel.fromJson(Map<String, dynamic> json) {
    return HomeDoctorModel(
      doctor: DoctorApiModel.fromJson(json),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': doctor.fullName,
      'specialty': doctor.specialization,
      'averageRating': doctor.averageRating,
      'totalReviews': doctor.totalReviews,
      'clinicAddress': doctor.clinicAddress,
      'profilePictureUrl': doctor.profilePictureUrl,
      'clinicImagesUrls': doctor.clinicImagesUrls,
      'isAvailable': doctor.isAvailable,
      'isFavorite': isFavorite,
    };
  }

  String get name => doctor.fullName;
  String get id => doctor.id.toString();
  String get specialty => doctor.specialization ?? 'General';
  String get speciality => specialty; // Alias for UI consistency
  String get hospital => doctor.hospital ?? 'Clinic';
  double get rating => doctor.averageRating ?? 0.0;
  int get reviewCount => doctor.totalReviews;
  String get reviews => reviewCount.toString(); // For favorite_doctor_card.dart
  String get fee => '\$100'; // Default fee for now
  String get imageAsset => (doctor.profilePictureUrl != null && doctor.profilePictureUrl!.isNotEmpty)
      ? doctor.profilePictureUrl!
      : 'assets/images/doctor1.png';
  bool get isAvailable => doctor.isAvailable;

  // New themed getters
  IconData get specialtyIcon => SpecialtyMapper.getThemeForSpecialty(specialty).icon;
  Color get specialtyColor => SpecialtyMapper.getThemeForSpecialty(specialty).color;
  Color get specialtyBgColor => SpecialtyMapper.getThemeForSpecialty(specialty).bgColor;
}
