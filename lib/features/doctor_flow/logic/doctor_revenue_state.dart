import 'package:equatable/equatable.dart';
import 'package:doctor_appointment/features/doctor_flow/domain/entities/doctor_monthly_revenue.dart';
import 'package:doctor_appointment/features/doctor_flow/domain/entities/doctor_daily_revenue.dart';

abstract class DoctorRevenueState extends Equatable {
  const DoctorRevenueState();

  @override
  List<Object?> get props => [];
}

class DoctorRevenueInitial extends DoctorRevenueState {}

class DoctorRevenueLoading extends DoctorRevenueState {}

class DoctorRevenueSuccess extends DoctorRevenueState {
  final List<DoctorMonthlyRevenue> monthlyRevenues;
  final List<DoctorDailyRevenue> dailyRevenues;

  const DoctorRevenueSuccess({
    required this.monthlyRevenues,
    required this.dailyRevenues,
  });

  @override
  List<Object?> get props => [monthlyRevenues, dailyRevenues];

  DoctorRevenueSuccess copyWith({
    List<DoctorMonthlyRevenue>? monthlyRevenues,
    List<DoctorDailyRevenue>? dailyRevenues,
  }) {
    return DoctorRevenueSuccess(
      monthlyRevenues: monthlyRevenues ?? this.monthlyRevenues,
      dailyRevenues: dailyRevenues ?? this.dailyRevenues,
    );
  }
}

class DoctorRevenueFailure extends DoctorRevenueState {
  final String message;

  const DoctorRevenueFailure(this.message);

  @override
  List<Object?> get props => [message];
}
