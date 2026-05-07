import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/doctors/domain/entities/doctors_page.dart';

abstract class DoctorsRepository {
  Future<Result<DoctorsPage>> searchDoctors({
    int? specializationId,
    double? minRating,
    String? searchTerm,
    int? pageNumber,
    int? pageSize,
  });
}
