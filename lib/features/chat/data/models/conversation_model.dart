class ConversationModel {
  final int otherUserId;
  final String otherUserName;
  final String? otherUserProfilePicture;
  final String otherUserRole;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ConversationModel({
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserProfilePicture,
    required this.otherUserRole,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      otherUserId: json['otherUserId'] as int? ?? 0,
      otherUserName: json['otherUserName'] as String? ?? 'Unknown',
      otherUserProfilePicture: json['otherUserProfilePicture'] as String?,
      otherUserRole: json['otherUserRole'] as String? ?? 'User',
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'] as String)
          : DateTime.now(),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'otherUserProfilePicture': otherUserProfilePicture,
      'otherUserRole': otherUserRole,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }
}
