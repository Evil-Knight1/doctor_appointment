import 'package:doctor_appointment/core/utils/app_colors.dart';
import 'package:doctor_appointment/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctor_appointment/core/utils/app_dimensions.dart';
import 'package:doctor_appointment/features/home/domain/entities/notification_entity.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification, this.onTap});
  final NotificationEntity notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = _getThemeForType(notification.type);
    final timeAgo = _formatTimestamp(notification.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.surface
              : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: notification.isRead
              ? null
              : Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 1.w,
                ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withValues(alpha: 0.07),
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: theme.bg,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(theme.icon, color: theme.color, size: 22.sp),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.headingSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(timeAgo, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.message,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!notification.isRead) ...[
              SizedBox(width: 8.w),
              Container(
                width: 8.w,
                height: 8.h,
                margin: EdgeInsets.only(top: 4.h),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  _NotificationTheme _getThemeForType(int type) {
    // Standard mapping for notification types
    switch (type) {
      case 235: // Success / Appointment
      case 1:
        return const _NotificationTheme(
          icon: Icons.check_circle_rounded,
          color: Color(0xFF10B981), // Success Green
          bg: Color(0xFFECFDF5),
        );
      case 2170: // Info / Update
      case 2:
        return const _NotificationTheme(
          icon: Icons.info_rounded,
          color: Color(0xFF3B82F6), // Info Blue
          bg: Color(0xFFEFF6FF),
        );
      case 3: // Warning / Reminder
        return const _NotificationTheme(
          icon: Icons.warning_rounded,
          color: Color(0xFFF59E0B), // Warning Orange
          bg: Color(0xFFFFFBEB),
        );
      case 4: // Error / Alert
        return const _NotificationTheme(
          icon: Icons.error_rounded,
          color: Color(0xFFEF4444), // Error Red
          bg: Color(0xFFFEF2F2),
        );
      default:
        return const _NotificationTheme(
          icon: Icons.notifications_rounded,
          color: AppColors.primary,
          bg: AppColors.primaryLight,
        );
    }
  }
}

class _NotificationTheme {
  final IconData icon;
  final Color color;
  final Color bg;

  const _NotificationTheme({
    required this.icon,
    required this.color,
    required this.bg,
  });
}
