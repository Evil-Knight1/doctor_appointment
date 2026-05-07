import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_appointment/core/services/service_locator.dart';
import 'package:doctor_appointment/features/home/logic/notification_cubit.dart';
import 'package:doctor_appointment/features/home/logic/notification_state.dart';
import '../widgets/notification_tile.dart';
import '../widgets/shared_app_bar.dart';
import 'package:doctor_appointment/core/utils/app_dimensions.dart';
import 'package:doctor_appointment/core/utils/app_colors.dart';
import 'package:doctor_appointment/core/utils/app_styles.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>()..fetchNotifications(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return SharedAppBar(
      title: 'Notification',
      actions: [
        BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationSuccess && state.unreadCount > 0) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      '${state.unreadCount} NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NotificationError) {
          return Center(child: Text(state.message));
        } else if (state is NotificationSuccess) {
          final notifications = state.notifications;
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 80.sp,
                    color: AppColors.textSecondary.withValues(alpha: 0.2),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'No notifications yet',
                    style: AppTextStyles.headingSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'We\'ll notify you when something important happens',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Simple grouping for UI (can be enhanced to group by Today/Yesterday)
          return RefreshIndicator(
            onRefresh: () => context.read<NotificationCubit>().fetchNotifications(),
            child: ListView.builder(
              padding: EdgeInsets.all(AppSpacing.lg),
              itemCount: notifications.length + 1, // +1 for the Mark All label
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: _SectionLabel(
                      label: 'All Notifications',
                      onMarkAll: () => context.read<NotificationCubit>().markAllAsRead(),
                    ),
                  );
                }
                final notification = notifications[index - 1];
                return NotificationTile(
                  notification: notification,
                  onTap: () => context.read<NotificationCubit>().markAsRead(notification.id),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.onMarkAll});
  final String label;
  final VoidCallback? onMarkAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.headingSmall),
        if (onMarkAll != null)
          GestureDetector(
            onTap: onMarkAll,
            child: Text(
              'Mark all as read',
              style: AppTextStyles.labelLarge,
            ),
          ),
      ],
    );
  }
}
