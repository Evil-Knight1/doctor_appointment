import 'package:doctor_appointment/features/home/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications({bool unreadOnly = false});
  Future<int> getUnreadCount();
  Future<bool> markAllAsRead();
  Future<bool> markAsRead(int id);
}
