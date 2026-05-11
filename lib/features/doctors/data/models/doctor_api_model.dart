import 'package:doctor_appointment/features/doctors/domain/entities/doctor.dart';

class DoctorApiModel extends Doctor {
  const DoctorApiModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.specialization,
    required super.bio,
    required super.yearsOfExperience,
    required super.clinicAddress,
    required super.hospital,
    required super.isApproved,
    required super.averageRating,
    required super.totalReviews,
    required super.createdAt,
    required super.specializationId,
    required super.isAvailable,
    required super.profilePictureUrl,
    required super.clinicImagesUrls,
    super.consultationFee,
  });

  factory DoctorApiModel.fromJson(Map<String, dynamic> json) {
    return DoctorApiModel(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      specialization:
          (json['specialization'] as String?) ??
          (json['specializationName'] as String?),
      bio: json['bio'] as String?,
      yearsOfExperience: json['yearsOfExperience'] as int?,
      clinicAddress: json['clinicAddress'] as String?,
      hospital: json['hospital'] as String?,
      isApproved: json['isApproved'] as bool? ?? false,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      totalReviews: json['totalReviews'] as int? ?? 0,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      specializationId: json['specializationId'] as int? ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? false,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      clinicImagesUrls: (json['clinicImagesUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      consultationFee: (json['consultationFee'] as num?)?.toDouble(),
    );
  }
}
