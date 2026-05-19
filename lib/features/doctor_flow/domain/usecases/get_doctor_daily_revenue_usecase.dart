import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/doctor_flow/domain/entities/doctor_daily_revenue.dart';
import 'package:doctor_appointment/features/doctor_flow/domain/repositories/doctor_stats_repository.dart';

class GetDoctorDailyRevenueUseCase {
  final DoctorStatsRepository repository;
  GetDoctorDailyRevenueUseCase(this.repository);

  Future<Result<List<DoctorDailyRevenue>>> call(int year, int month) {
    return repository.getDailyRevenue(year, month);
  }
}
