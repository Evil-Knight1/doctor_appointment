import 'package:equatable/equatable.dart';
import 'package:doctor_appointment/features/payments/domain/entities/payment_history_item.dart';

sealed class PaymentHistoryState extends Equatable {
  const PaymentHistoryState();

  @override
  List<Object?> get props => [];
}

class PaymentHistoryInitial extends PaymentHistoryState {
  const PaymentHistoryInitial();
}

class PaymentHistoryLoading extends PaymentHistoryState {
  const PaymentHistoryLoading();
}

class PaymentHistorySuccess extends PaymentHistoryState {
  final List<PaymentHistoryItem> payments;

  const PaymentHistorySuccess(this.payments);

  @override
  List<Object?> get props => [payments];
}

class PaymentHistoryFailure extends PaymentHistoryState {
  final String message;

  const PaymentHistoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
