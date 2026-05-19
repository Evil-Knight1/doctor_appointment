import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/doctor_flow/domain/repositories/doctor_stats_repository.dart';
import 'package:doctor_appointment/features/appointment/domain/entities/appointment.dart';

class UpdateAppointmentStatusUseCase {
  final DoctorStatsRepository repository;
  UpdateAppointmentStatusUseCase(this.repository);

  Future<Result<Appointment>> call(int appointmentId, int status, {String? notes}) {
    return repository.updateAppointmentStatus(appointmentId, status, notes: notes);
  }
}
