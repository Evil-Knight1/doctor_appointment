import 'package:doctor_appointment/core/errors/exceptions.dart';
import 'package:doctor_appointment/core/errors/failures.dart';
import 'package:doctor_appointment/features/home/data/datasource/notification_remote_data_source.dart';
import 'package:doctor_appointment/features/home/domain/entities/notification_entity.dart';
import 'package:doctor_appointment/features/home/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications({bool unreadOnly = false}) async {
    try {
      return await remoteDataSource.getNotifications(unreadOnly: unreadOnly);
    } on ApiException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('An unexpected error occurred while fetching notifications');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      return await remoteDataSource.getUnreadCount();
    } on ApiException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('An unexpected error occurred while fetching unread count');
    }
  }

  @override
  Future<bool> markAllAsRead() async {
    try {
      return await remoteDataSource.markAllAsRead();
    } on ApiException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('An unexpected error occurred while marking notifications as read');
    }
  }

  @override
  Future<bool> markAsRead(int id) async {
    try {
      return await remoteDataSource.markAsRead(id);
    } on ApiException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('An unexpected error occurred while marking notification as read');
    }
  }
}
