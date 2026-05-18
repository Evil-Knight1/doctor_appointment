import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/payments/domain/entities/payment_history_item.dart';
import 'package:doctor_appointment/features/payments/domain/repositories/payment_repository.dart';

class GetMyPaymentsUseCase {
  final PaymentRepository repository;

  const GetMyPaymentsUseCase(this.repository);

  Future<Result<List<PaymentHistoryItem>>> call() {
    return repository.getMyPayments();
  }
}
