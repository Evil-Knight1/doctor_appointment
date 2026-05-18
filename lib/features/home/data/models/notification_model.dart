import 'package:doctor_appointment/features/home/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.type,
    required super.isRead,
    required super.createdAt,
    super.relatedEntityId,
    super.senderName,
    super.senderProfilePicture,
    super.senderRole,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: json['type'] as int?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      relatedEntityId: json['relatedEntityId'] as String?,
      senderName: json['senderName'] as String?,
      senderProfilePicture: json['senderProfilePicture'] as String?,
      senderRole: json['senderRole'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'relatedEntityId': relatedEntityId,
      'senderName': senderName,
      'senderProfilePicture': senderProfilePicture,
      'senderRole': senderRole,
    };
  }
}
