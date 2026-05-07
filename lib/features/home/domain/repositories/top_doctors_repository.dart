import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/doctors/domain/entities/specialization.dart';
import 'package:doctor_appointment/features/home/domain/entities/top_doctors.dart';

abstract interface class TopDoctorsRepository {
  Future<Result<TopDoctors>> getTopDoctors({int? count});
  Future<Result<TopDoctors>> getDoctorsBySpecialization(
    int specializationId, {
    int? count,
  });
  Future<Result<List<Specialization>>> getSpecializations();
}
