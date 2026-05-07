class NotificationEntity {
  final int id;
  final String title;
  final String message;
  final int type;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedEntityId;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedEntityId,
  });
}
