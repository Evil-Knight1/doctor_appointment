import 'package:doctor_appointment/core/theme/app_theme_extension.dart';
import 'package:doctor_appointment/features/on_boarding_view/presentation/widgets/custom_button.dart';
import 'package:doctor_appointment/features/payments/domain/entities/payment_history_item.dart';
import 'package:doctor_appointment/features/payments/domain/entities/payment_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionDetailsView extends StatelessWidget {
  const TransactionDetailsView({
    super.key,
    required this.payment,
  });

  final PaymentHistoryItem payment;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Transaction Details',
          style: context.styleSemiBold22.copyWith(
            fontSize: 18.sp,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    height: 80.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: _statusAccentColor(context).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _statusIcon(),
                      color: _statusAccentColor(context),
                      size: 40.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    payment.statusLabel,
                    style: context.styleSemiBold22.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    payment.formattedAmount,
                    style: context.styleSemiBold24.copyWith(
                      color: _statusAccentColor(context),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 48.h),
            _buildDetailRow(context, 'Transaction ID',
                payment.transactionId ?? 'Unavailable'),
            _buildDetailRow(
              context,
              'Date & Time',
              DateFormat('dd MMM yyyy, hh:mm a')
                  .format(payment.effectiveDate.toLocal()),
            ),
            _buildDetailRow(
              context,
              'Payment Method',
              payment.paymentMethodLabel,
            ),
            _buildDetailRow(
              context,
              'Payment Provider',
              payment.paymentProvider ?? 'Unknown',
            ),
            _buildDetailRow(
              context,
              'Doctor',
              payment.doctorName.isEmpty ? 'Unknown' : 'Dr. ${payment.doctorName}',
            ),
            _buildDetailRow(
              context,
              'Appointment ID',
              '#${payment.appointmentId}',
            ),
            if (payment.failureReason != null &&
                payment.failureReason!.trim().isNotEmpty)
              _buildDetailRow(context, 'Failure Reason', payment.failureReason!),
            const Spacer(),
            CustomButton(
              text: payment.status == PaymentStatus.pending && payment.paymentUrl?.isNotEmpty == true
                  ? 'Pay Now'
                  : 'Receipt Unavailable',
              onPressed: () async {
                if (payment.status == PaymentStatus.pending && payment.paymentUrl?.isNotEmpty == true) {
                  final url = Uri.parse(payment.paymentUrl!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No downloadable receipt is available yet.'),
                    ),
                  );
                }
              },
              width: double.infinity,
              height: 50.h,
              circleSize: 12.r,
              textStyle: context.styleSemiBold16.copyWith(
                color: colorScheme.onPrimary,
              ),
              buttonColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Color _statusAccentColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (payment.status) {
      PaymentStatus.paid => context.customColors.success ?? Colors.green,
      PaymentStatus.refunded => context.customColors.error ?? colorScheme.error,
      PaymentStatus.failed ||
      PaymentStatus.cancelled ||
      PaymentStatus.expired => colorScheme.error,
      PaymentStatus.processing => colorScheme.primary,
      _ => colorScheme.onSurfaceVariant,
    };
  }

  IconData _statusIcon() {
    return switch (payment.status) {
      PaymentStatus.paid => Icons.check_circle_rounded,
      PaymentStatus.processing => Icons.hourglass_top_rounded,
      PaymentStatus.refunded => Icons.undo_rounded,
      PaymentStatus.failed ||
      PaymentStatus.cancelled ||
      PaymentStatus.expired => Icons.cancel_rounded,
      _ => Icons.receipt_long_rounded,
    };
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: context.styleRegular14.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.styleSemiBold16.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
