import 'package:doctor_appointment/features/home/domain/entities/app_notification_type.dart';

class NotificationEntity {
  final int id;
  final String title;
  final String message;
  final int? type;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedEntityId;
  final String? senderName;
  final String? senderProfilePicture;
  final String? senderRole;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedEntityId,
    this.senderName,
    this.senderProfilePicture,
    this.senderRole,
  });

  AppNotificationType get notificationType => AppNotificationType.fromValue(type);

  int? get relatedEntityIntId => int.tryParse(relatedEntityId ?? '');

  NotificationEntity copyWith({
    int? id,
    String? title,
    String? message,
    int? type,
    bool? isRead,
    DateTime? createdAt,
    String? relatedEntityId,
    String? senderName,
    String? senderProfilePicture,
    String? senderRole,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      senderName: senderName ?? this.senderName,
      senderProfilePicture: senderProfilePicture ?? this.senderProfilePicture,
      senderRole: senderRole ?? this.senderRole,
    );
  }
}
