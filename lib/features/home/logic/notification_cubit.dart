import 'package:doctor_appointment/features/home/domain/repositories/notification_repository.dart';
import 'package:doctor_appointment/features/home/logic/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit(this.repository) : super(NotificationInitial());

  Future<void> fetchNotifications({bool unreadOnly = false}) async {
    emit(NotificationLoading());
    try {
      final notifications = await repository.getNotifications(unreadOnly: unreadOnly);
      final unreadCount = await repository.getUnreadCount();
      emit(NotificationSuccess(notifications, unreadCount));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await repository.markAllAsRead();
      await fetchNotifications();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await repository.markAsRead(id);
      await fetchNotifications();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final unreadCount = await repository.getUnreadCount();
      if (state is NotificationSuccess) {
        emit(NotificationSuccess((state as NotificationSuccess).notifications, unreadCount));
      } else {
        emit(NotificationSuccess(const [], unreadCount));
      }
    } catch (e) {
      // Don't emit error for background count fetch to avoid UI flicker
    }
  }
}
