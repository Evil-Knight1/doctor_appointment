import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/doctor_flow/domain/usecases/get_doctor_monthly_revenue_usecase.dart';
import 'package:doctor_appointment/features/doctor_flow/domain/usecases/get_doctor_daily_revenue_usecase.dart';
import 'package:doctor_appointment/features/doctor_flow/logic/doctor_revenue_state.dart';

class DoctorRevenueCubit extends Cubit<DoctorRevenueState> {
  final GetDoctorMonthlyRevenueUseCase getDoctorMonthlyRevenueUseCase;
  final GetDoctorDailyRevenueUseCase getDoctorDailyRevenueUseCase;

  DoctorRevenueCubit({
    required this.getDoctorMonthlyRevenueUseCase,
    required this.getDoctorDailyRevenueUseCase,
  }) : super(DoctorRevenueInitial());

  Future<void> fetchRevenueData({int? year, int? month}) async {
    final targetYear = year ?? DateTime.now().year;
    final targetMonth = month ?? DateTime.now().month;

    emit(DoctorRevenueLoading());

    final monthlyResult = await getDoctorMonthlyRevenueUseCase(targetYear);
    final dailyResult = await getDoctorDailyRevenueUseCase(targetYear, targetMonth);

    if (monthlyResult is Success && dailyResult is Success) {
      emit(DoctorRevenueSuccess(
        monthlyRevenues: monthlyResult.data,
        dailyRevenues: dailyResult.data,
      ));
    } else if (monthlyResult is FailureResult) {
      emit(DoctorRevenueFailure(monthlyResult.failure.message));
    } else if (dailyResult is FailureResult) {
      emit(DoctorRevenueFailure(dailyResult.failure.message));
    }
  }
}
