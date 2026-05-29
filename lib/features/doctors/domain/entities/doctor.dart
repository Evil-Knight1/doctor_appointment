import 'package:doctor_appointment/features/doctors/domain/entities/specialization.dart';

class Doctor {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final Specialization specialization;
  final int specializationId;
  final String? bio;
  final int? yearsOfExperience;
  final String? clinicAddress;
  final String? hospital;
  final bool isApproved;
  final double? averageRating;
  final int totalReviews;
  final DateTime createdAt;
  final String? profilePictureUrl;
  final List<String>? clinicImagesUrls;
  final bool isAvailable;
  final double? consultationPrice;
  final double? latitude;
  final double? longitude;

  const Doctor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.specializationId,
    required this.specialization,
    this.bio,
    this.yearsOfExperience,
    this.clinicAddress,
    this.hospital,
    required this.isApproved,
    this.averageRating,
    required this.totalReviews,
    required this.createdAt,
    this.profilePictureUrl,
    this.clinicImagesUrls,
    required this.isAvailable,
    this.consultationPrice,
    this.latitude,
    this.longitude,
  });
}
