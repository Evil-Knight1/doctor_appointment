import 'package:doctor_appointment/features/doctors/domain/entities/doctor.dart';

class TopDoctors {
  final List<Doctor> doctors;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  const TopDoctors({
    required this.doctors,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });
}
