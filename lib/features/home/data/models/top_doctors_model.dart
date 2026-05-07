import 'package:doctor_appointment/features/home/data/models/home_doctor_model.dart';
import 'package:doctor_appointment/features/home/domain/entities/top_doctors.dart';

class TopDoctorsModel extends TopDoctors {
  TopDoctorsModel({
    required super.doctors,
    required super.pageNumber,
    required super.pageSize,
    required super.totalCount,
    required super.totalPages,
  });

  factory TopDoctorsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final doctors =
        data
            .map((e) => HomeDoctorModel.fromJson(e as Map<String, dynamic>).doctor)
            .toList();

    return TopDoctorsModel(
      doctors: doctors,
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? doctors.length,
      totalCount: json['totalCount'] as int? ?? doctors.length,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}
