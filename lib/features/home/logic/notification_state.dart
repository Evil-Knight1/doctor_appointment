import 'package:doctor_appointment/features/home/domain/entities/notification_entity.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  NotificationSuccess(this.notifications, this.unreadCount);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
