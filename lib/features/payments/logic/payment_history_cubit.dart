import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/payments/domain/usecases/get_my_payments_usecase.dart';
import 'package:doctor_appointment/features/payments/logic/payment_history_state.dart';

class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  final GetMyPaymentsUseCase _getMyPaymentsUseCase;

  PaymentHistoryCubit(this._getMyPaymentsUseCase)
      : super(const PaymentHistoryInitial());

  Future<void> fetchPayments() async {
    emit(const PaymentHistoryLoading());
    final result = await _getMyPaymentsUseCase();
    switch (result) {
      case Success():
        emit(PaymentHistorySuccess(result.data));
      case FailureResult():
        emit(PaymentHistoryFailure(result.failure.message));
    }
  }
}
