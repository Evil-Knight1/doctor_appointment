import 'package:doctor_appointment/features/doctor_flow/domain/entities/doctor_daily_revenue.dart';

class DoctorDailyRevenueModel extends DoctorDailyRevenue {
  const DoctorDailyRevenueModel({
    required super.date,
    required super.revenue,
    required super.appointmentCount,
  });

  factory DoctorDailyRevenueModel.fromJson(Map<String, dynamic> json) {
    return DoctorDailyRevenueModel(
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      appointmentCount: json['appointmentCount'] as int? ?? 0,
    );
  }
}
