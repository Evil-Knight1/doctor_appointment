import 'package:doctor_appointment/features/doctor_flow/domain/entities/doctor_monthly_revenue.dart';

class DoctorMonthlyRevenueModel extends DoctorMonthlyRevenue {
  const DoctorMonthlyRevenueModel({
    required super.year,
    required super.month,
    required super.monthName,
    required super.revenue,
    required super.appointmentCount,
  });

  factory DoctorMonthlyRevenueModel.fromJson(Map<String, dynamic> json) {
    return DoctorMonthlyRevenueModel(
      year: json['year'] as int? ?? 0,
      month: json['month'] as int? ?? 0,
      monthName: json['monthName'] as String? ?? '',
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      appointmentCount: json['appointmentCount'] as int? ?? 0,
    );
  }
}
