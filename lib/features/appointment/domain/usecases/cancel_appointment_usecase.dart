import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/appointment/domain/repositories/appointment_repository.dart';

class CancelAppointmentUseCase {
  final AppointmentRepository repository;

  const CancelAppointmentUseCase(this.repository);

  Future<Result<void>> call(int appointmentId) {
    return repository.cancelAppointment(appointmentId);
  }
}
