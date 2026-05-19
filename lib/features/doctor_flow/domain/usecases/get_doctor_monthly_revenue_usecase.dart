import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/doctor_flow/domain/entities/doctor_monthly_revenue.dart';
import 'package:doctor_appointment/features/doctor_flow/domain/repositories/doctor_stats_repository.dart';

class GetDoctorMonthlyRevenueUseCase {
  final DoctorStatsRepository repository;
  GetDoctorMonthlyRevenueUseCase(this.repository);

  Future<Result<List<DoctorMonthlyRevenue>>> call(int year) {
    return repository.getMonthlyRevenue(year);
  }
}
