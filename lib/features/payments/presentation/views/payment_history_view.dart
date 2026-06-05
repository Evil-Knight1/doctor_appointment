import 'package:doctor_appointment/core/theme/app_theme_extension.dart';
import 'package:doctor_appointment/core/utils/go_router.dart';
import 'package:doctor_appointment/features/payments/domain/entities/payment_history_item.dart';
import 'package:doctor_appointment/features/payments/domain/entities/payment_status.dart';
import 'package:doctor_appointment/features/payments/logic/payment_history_cubit.dart';
import 'package:doctor_appointment/features/payments/logic/payment_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PaymentHistoryView extends StatelessWidget {
  const PaymentHistoryView({super.key});

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
          'Payment History',
          style: context.styleSemiBold22.copyWith(
            fontSize: 18.sp,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
        builder: (context, state) {
          return switch (state) {
            PaymentHistoryInitial() => const _PaymentHistoryLoading(),
            PaymentHistoryLoading() => const _PaymentHistoryLoading(),
            PaymentHistoryFailure() => _PaymentHistoryFailure(
              message: state.message,
              onRetry: () =>
                  context.read<PaymentHistoryCubit>().fetchPayments(),
            ),
            PaymentHistorySuccess() when state.payments.isEmpty =>
              const _PaymentHistoryEmpty(),
            PaymentHistorySuccess() => RefreshIndicator(
              onRefresh: () =>
                  context.read<PaymentHistoryCubit>().fetchPayments(),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                itemCount: state.payments.length,
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final payment = state.payments[index];
                  return GestureDetector(
                    onTap: () => context.push(
                      AppRouter.kTransactionDetailsView,
                      extra: payment,
                    ),
                    child: _PaymentHistoryCard(payment: payment),
                  );
                },
              ),
            ),
          };
        },
      ),
    );
  }
}

class _PaymentHistoryCard extends StatelessWidget {
  const _PaymentHistoryCard({required this.payment});

  final PaymentHistoryItem payment;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customColors = context.customColors;
    final statusColor = switch (payment.status) {
      PaymentStatus.paid => customColors.success ?? Colors.green,
      PaymentStatus.refunded => customColors.error ?? colorScheme.error,
      PaymentStatus.failed ||
      PaymentStatus.cancelled ||
      PaymentStatus.expired => colorScheme.error,
      PaymentStatus.processing => colorScheme.primary,
      _ => colorScheme.onSurfaceVariant,
    };

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_rounded,
              color: colorScheme.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.title,
                  style: context.styleMedium14.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Appointment #${payment.appointmentId}',
                  style: context.styleRegular12.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      payment.statusLabel,
                      style: context.styleRegular12.copyWith(
                        color: statusColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 4.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: colorScheme.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        DateFormat(
                          'dd MMM yyyy, hh:mm a',
                        ).format(payment.effectiveDate.toLocal()),
                        style: context.styleRegular12.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                payment.formattedAmount,
                style: context.styleSemiBold16.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 6.h),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentHistoryLoading extends StatelessWidget {
  const _PaymentHistoryLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: 6,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (_, _) => Container(
        height: 96.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}

class _PaymentHistoryEmpty extends StatelessWidget {
  const _PaymentHistoryEmpty();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 12.h),
            Text(
              'No payments yet',
              style: context.styleSemiBold22.copyWith(
                fontSize: 18.sp,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your completed and pending payment records will appear here.',
              textAlign: TextAlign.center,
              style: context.styleRegular14.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentHistoryFailure extends StatelessWidget {
  const _PaymentHistoryFailure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56.sp,
              color: colorScheme.error,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.styleRegular14.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
