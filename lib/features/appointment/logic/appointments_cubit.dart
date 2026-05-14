import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/appointment/domain/usecases/get_my_appointments_usecase.dart';
import 'package:doctor_appointment/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:doctor_appointment/features/appointment/logic/appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final GetMyAppointmentsUseCase getMyAppointmentsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;

  AppointmentsCubit({
    required this.getMyAppointmentsUseCase,
    required this.cancelAppointmentUseCase,
  }) : super(const AppointmentsInitial());

  Future<void> loadAppointments() async {
    emit(const AppointmentsLoading());
    final result = await getMyAppointmentsUseCase();

    switch (result) {
      case Success():
        emit(AppointmentsSuccess(result.data));
      case FailureResult():
        emit(AppointmentsFailure(result.failure.message));
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final result = await cancelAppointmentUseCase(appointmentId);

    if (result is Success) {
      // Reload appointments after successful cancellation
      await loadAppointments();
    } else if (result is FailureResult) {
      emit(AppointmentsFailure(result.failure.message));
    }
  }
}
