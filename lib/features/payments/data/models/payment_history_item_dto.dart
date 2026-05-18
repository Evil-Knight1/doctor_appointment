import 'package:doctor_appointment/features/payments/domain/entities/payment_history_item.dart';
import 'package:doctor_appointment/features/payments/domain/entities/payment_status.dart';

class PaymentHistoryItemDto {
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

  const PaymentHistoryItemDto({
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

  factory PaymentHistoryItemDto.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status'];
    return PaymentHistoryItemDto(
      id: json['id'] as int? ?? 0,
      appointmentId: json['appointmentId'] as int? ?? 0,
      patientId: json['patientId'] as int? ?? 0,
      patientName: json['patientName'] as String? ?? '',
      doctorId: json['doctorId'] as int? ?? 0,
      doctorName: json['doctorName'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      paymentMethodCode: json['paymentMethod'] as int?,
      status: _parseStatus(rawStatus),
      statusCode: rawStatus is int ? rawStatus : int.tryParse('$rawStatus'),
      transactionId: json['transactionId'] as String?,
      paymentProvider: json['paymentProvider'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      paidAt: DateTime.tryParse(json['paidAt'] as String? ?? ''),
      failureReason: json['failureReason'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
    );
  }

  PaymentHistoryItem toDomain() => PaymentHistoryItem(
        id: id,
        appointmentId: appointmentId,
        patientId: patientId,
        patientName: patientName,
        doctorId: doctorId,
        doctorName: doctorName,
        amount: amount,
        paymentMethodCode: paymentMethodCode,
        status: status,
        statusCode: statusCode,
        transactionId: transactionId,
        paymentProvider: paymentProvider,
        createdAt: createdAt,
        paidAt: paidAt,
        failureReason: failureReason,
        paymentUrl: paymentUrl,
      );

  static PaymentStatus _parseStatus(dynamic rawStatus) {
    if (rawStatus is String) {
      return PaymentStatus.fromString(rawStatus);
    }

    if (rawStatus is int) {
      switch (rawStatus) {
        case 0:
          return PaymentStatus.pending;
        case 1:
          return PaymentStatus.processing;
        case 2:
          return PaymentStatus.paid;
        case 3:
          return PaymentStatus.failed;
        case 4:
          return PaymentStatus.cancelled;
        case 5:
          return PaymentStatus.refunded;
        case 6:
          return PaymentStatus.expired;
        default:
          return PaymentStatus.unknown;
      }
    }

    return PaymentStatus.unknown;
  }
}
