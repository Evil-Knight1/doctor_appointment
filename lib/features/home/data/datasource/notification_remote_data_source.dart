import 'package:doctor_appointment/core/errors/exceptions.dart';
import 'package:doctor_appointment/core/services/api_service.dart';
import 'package:doctor_appointment/features/home/data/models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({bool unreadOnly = false});
  Future<int> getUnreadCount();
  Future<bool> markAllAsRead();
  Future<bool> markAsRead(int id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiService apiService;

  NotificationRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<NotificationModel>> getNotifications({
    bool unreadOnly = false,
  }) async {
    final response = await apiService.get(
      '/api/Notification',
      queryParameters: {'unreadOnly': unreadOnly},
    );

    if (response['success'] != true) {
      throw ApiException(
        response['message'] as String? ?? 'Failed to load notifications',
      );
    }

    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await apiService.get('/api/Notification/unread-count');

    if (response['success'] != true) {
      throw ApiException(
        response['message'] as String? ?? 'Failed to load unread count',
      );
    }

    return response['data'] as int? ?? 0;
  }

  @override
  Future<bool> markAllAsRead() async {
    final response = await apiService.put('/api/Notification/read-all');

    if (response['success'] != true) {
      throw ApiException(
        response['message'] as String? ?? 'Failed to mark all as read',
      );
    }

    return response['data'] as bool? ?? false;
  }

  @override
  Future<bool> markAsRead(int id) async {
    final response = await apiService.put('/api/Notification/$id/read');

    if (response['success'] != true) {
      throw ApiException(
        response['message'] as String? ?? 'Failed to mark as read',
      );
    }

    return response['data'] as bool? ?? false;
  }
}
