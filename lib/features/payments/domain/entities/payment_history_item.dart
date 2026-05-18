import 'package:equatable/equatable.dart';
import 'package:doctor_appointment/features/payments/domain/entities/payment_status.dart';

class PaymentHistoryItem extends Equatable {
  final int id;
  final int appointmentId;
  final int patientId;
  final String patientName;
  final int doctorId;
  final String doctorName;
  final double amount;
  final int? paymentMethodCode;
  final PaymentStatus status;
  final int? statusCode;
  final String? transactionId;
  final String? paymentProvider;
  final DateTime createdAt;
  final DateTime? paidAt;
  final String? failureReason;
  final String? paymentUrl;

  const PaymentHistoryItem({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.amount,
    required this.paymentMethodCode,
    required this.status,
    required this.statusCode,
    required this.transactionId,
    required this.paymentProvider,
    required this.createdAt,
    required this.paidAt,
    required this.failureReason,
    required this.paymentUrl,
  });

  String get formattedAmount => 'EGP ${amount.toStringAsFixed(2)}';

  String get statusLabel => switch (status) {
    PaymentStatus.pending => 'Pending',
    PaymentStatus.processing => 'Processing',
    PaymentStatus.paid => 'Completed',
    PaymentStatus.failed => 'Failed',
    PaymentStatus.cancelled => 'Cancelled',
    PaymentStatus.refunded => 'Refunded',
    PaymentStatus.expired => 'Expired',
    PaymentStatus.unknown => statusCode != null
        ? 'Status #$statusCode'
        : 'Unknown',
  };

  String get paymentMethodLabel => switch (paymentMethodCode) {
    1 => 'Card',
    2 => 'Wallet',
    3 => 'Cash',
    4 => 'Bank Transfer',
    null => 'Unknown',
    _ => 'Method #$paymentMethodCode',
  };

  String get title =>
      doctorName.trim().isNotEmpty ? 'Dr. $doctorName' : 'Payment #$id';

  DateTime get effectiveDate => paidAt ?? createdAt;

  @override
  List<Object?> get props => [
        id,
        appointmentId,
        patientId,
        patientName,
        doctorId,
        doctorName,
        amount,
        paymentMethodCode,
        status,
        statusCode,
        transactionId,
        paymentProvider,
        createdAt,
        paidAt,
        failureReason,
        paymentUrl,
      ];
}
