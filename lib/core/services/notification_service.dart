import 'dart:convert';

import 'package:doctor_appointment/core/config/env.dart';
import 'package:doctor_appointment/core/logging/log_service.dart';
import 'package:doctor_appointment/core/services/service_locator.dart';
import 'package:doctor_appointment/core/services/shared_preferences_helper.dart';
import 'package:doctor_appointment/core/utils/go_router.dart';
import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/appointment/domain/entities/appointment.dart';
import 'package:doctor_appointment/features/appointment/domain/usecases/get_my_appointments_usecase.dart';
import 'package:doctor_appointment/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:doctor_appointment/features/chat/data/models/conversation_model.dart';
import 'package:doctor_appointment/features/home/data/datasource/notification_remote_data_source.dart';
import 'package:doctor_appointment/features/home/domain/entities/app_notification_type.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const String _replyActionId = 'reply_action';
const String _seenActionId = 'seen_action';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.ensureBackgroundDependencies();
  await NotificationService().handleNotificationResponse(response);
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  bool _initialized = false;
  bool _localNotificationsInitialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await _ensureLocalNotificationsInitialized();

    FirebaseMessaging.onMessage.listen((message) async {
      await showRemoteMessageNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _navigateBasedOnData(message.data);
    });

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _navigateBasedOnData(initialMessage.data);
    }

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  static Future<void> ensureBackgroundDependencies() async {
    await loadEnv();
    await SharedPreferencesHelper.init();
    if (!getIt.isRegistered<NotificationRemoteDataSource>()) {
      setupServiceLocator();
    }
    tz.initializeTimeZones();
    await NotificationService()._ensureLocalNotificationsInitialized();
  }

  static Future<void> handleBackgroundRemoteMessage(RemoteMessage message) async {
    WidgetsFlutterBinding.ensureInitialized();
    await ensureBackgroundDependencies();
    await NotificationService().showRemoteMessageNotification(
      message,
      fromBackground: true,
    );
  }

  Future<String?> getFcmToken() async => _fcm.getToken();

  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  Future<void> showRemoteMessageNotification(
    RemoteMessage message, {
    bool fromBackground = false,
  }) async {
    if (fromBackground && message.notification != null) {
      return;
    }

    final title = _extractNotificationTitle(message);
    final body = _extractNotificationBody(message);
    if (title == null && body == null) return;

    final payloadMap = Map<String, dynamic>.from(message.data);
    payloadMap['title'] ??= title;
    payloadMap['message'] ??= body;

    await showNotification(
      id: message.messageId?.hashCode ?? message.hashCode,
      title: title ?? 'New Notification',
      body: body ?? '',
      payload: jsonEncode(payloadMap),
      type: _parseNotificationType(payloadMap['type']),
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    AppNotificationType? type,
  }) async {
    final notificationType = type ?? AppNotificationType.unknown;

    final androidDetails = AndroidNotificationDetails(
      'doctor_appointment_channel',
      'Doctor Appointment Notifications',
      channelDescription:
          'Notifications for appointments, status changes, and new messages.',
      importance: Importance.max,
      priority: Priority.high,
      category: notificationType.isChat
          ? AndroidNotificationCategory.message
          : AndroidNotificationCategory.event,
      showWhen: true,
      actions: notificationType.isChat
          ? <AndroidNotificationAction>[
              AndroidNotificationAction(
                _replyActionId,
                'Reply',
                allowGeneratedReplies: true,
                cancelNotification: false,
                contextual: true,
                semanticAction: SemanticAction.reply,
                inputs: const <AndroidNotificationActionInput>[
                  AndroidNotificationActionInput(label: 'Type a reply'),
                ],
              ),
              const AndroidNotificationAction(
                _seenActionId,
                'Seen',
                semanticAction: SemanticAction.markAsRead,
              ),
            ]
          : null,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'doctor_appointment_channel',
          'Doctor Appointment Notifications',
          channelDescription:
              'Notifications for appointments, status changes, and new messages.',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.event,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> handleNotificationResponse(NotificationResponse response) async {
    final payload = response.payload;
    if (payload == null) return;

    try {
      final data = Map<String, dynamic>.from(jsonDecode(payload) as Map);

      switch (response.actionId) {
        case _replyActionId:
          final replyText = response.input?.trim();
          if (replyText != null && replyText.isNotEmpty) {
            await _sendQuickReply(data, replyText);
          }
          await _markAsSeenFromPayload(data);
          break;
        case _seenActionId:
          await _markAsSeenFromPayload(data);
          break;
        default:
          _navigateBasedOnData(data);
          break;
      }
    } catch (error, stackTrace) {
      if (getIt.isRegistered<LogService>()) {
        getIt<LogService>().e(
          'Error handling notification response',
          error,
          stackTrace,
        );
      }
    }
  }

  void _navigateBasedOnData(Map<String, dynamic> data) {
    final type = _parseNotificationType(data['type']);
    if (type.isChat || _isChatPayload(data)) {
      _openChatFromNotification(data);
    } else if (type.isAppointmentFlow ||
        data['appointmentId'] != null ||
        data['relatedEntityId'] != null) {
      final idStr = data['appointmentId'] ?? data['relatedEntityId'];
      final appointmentId =
          idStr != null ? int.tryParse(idStr.toString()) : null;
      if (appointmentId != null) {
        _handleAppointmentTapAsync(appointmentId);
      } else {
        AppRouter.router.push(AppRouter.kCalendarView);
      }
    } else {
      AppRouter.router.push(AppRouter.kNotificationView);
    }
  }

  void _openChatFromNotification(Map<String, dynamic> data) async {
    final fallbackUserId = _parseInt(
      data['userId'] ??
          data['senderId'] ??
          data['chatUserId'] ??
          data['relatedEntityId'],
    );

    final userName = (data['userName'] ?? data['senderName'] ?? 'Chat')
        .toString()
        .trim();
    final userProfilePicture =
        (data['userProfilePicture'] ?? data['senderProfilePicture'])
            ?.toString();

    try {
      final chatRemoteDataSource = getIt<ChatRemoteDataSource>();
      final conversations = await chatRemoteDataSource.getConversations();
      final matchedConversation = _matchConversationFromData(
        conversations,
        data,
      );

      final resolvedUserId = matchedConversation?.otherUserId ?? fallbackUserId;
      if (resolvedUserId == null) {
        AppRouter.router.push(AppRouter.kConversationsView);
        return;
      }

      AppRouter.router.push(
        AppRouter.kChatView.replaceFirst(':userId', '$resolvedUserId'),
        extra: {
          'otherUserName':
              matchedConversation?.otherUserName.isNotEmpty == true
              ? matchedConversation!.otherUserName
              : userName,
          'otherUserProfilePicture':
              matchedConversation?.otherUserProfilePicture ?? userProfilePicture,
        },
      );
    } catch (_) {
      if (fallbackUserId == null) {
        AppRouter.router.push(AppRouter.kConversationsView);
        return;
      }

      AppRouter.router.push(
        AppRouter.kChatView.replaceFirst(':userId', '$fallbackUserId'),
        extra: {
          'otherUserName': userName,
          'otherUserProfilePicture': userProfilePicture,
        },
      );
    }
  }

  Future<void> _sendQuickReply(
    Map<String, dynamic> data,
    String replyText,
  ) async {
    final chatRemoteDataSource = getIt<ChatRemoteDataSource>();
    final conversations = await chatRemoteDataSource.getConversations();
    final matchedConversation = _matchConversationFromData(conversations, data);
    final resolvedUserId = matchedConversation?.otherUserId ??
        _parseInt(
          data['userId'] ??
              data['senderId'] ??
              data['chatUserId'] ??
              data['relatedEntityId'],
        );

    if (resolvedUserId == null) {
      throw Exception('Could not resolve conversation for quick reply');
    }

    await chatRemoteDataSource.sendMessage(resolvedUserId, replyText);
  }

  Future<void> _markAsSeenFromPayload(Map<String, dynamic> data) async {
    final notificationId = _parseInt(data['notificationId'] ?? data['id']);
    if (notificationId != null) {
      try {
        await getIt<NotificationRemoteDataSource>().markAsRead(notificationId);
      } catch (_) {}
    }

    final chatRemoteDataSource = getIt<ChatRemoteDataSource>();
    final conversations = await chatRemoteDataSource.getConversations();
    final matchedConversation = _matchConversationFromData(conversations, data);
    final resolvedUserId = matchedConversation?.otherUserId ??
        _parseInt(
          data['userId'] ??
              data['senderId'] ??
              data['chatUserId'] ??
              data['relatedEntityId'],
        );

    if (resolvedUserId != null) {
      try {
        await chatRemoteDataSource.markAsRead(resolvedUserId);
      } catch (_) {}
    }
  }

  void _handleAppointmentTapAsync(int appointmentId) async {
    try {
      final useCase = getIt<GetMyAppointmentsUseCase>();
      final result = await useCase();
      if (result is Success<List<Appointment>>) {
        final appointment = result.data.firstWhere(
          (app) => app.id == appointmentId,
          orElse: () => throw Exception('Appointment not found'),
        );
        AppRouter.router.push(
          AppRouter.kAppointmentDetailsView,
          extra: appointment,
        );
      } else {
        AppRouter.router.push(AppRouter.kCalendarView);
      }
    } catch (_) {
      AppRouter.router.push(AppRouter.kCalendarView);
    }
  }

  AppNotificationType _parseNotificationType(dynamic rawType) {
    if (rawType is int) {
      return AppNotificationType.fromValue(rawType);
    }

    if (rawType is String) {
      final normalized = rawType.trim().toLowerCase();
      if (normalized == 'chat' || normalized == 'chatmessage') {
        return AppNotificationType.chatMessage;
      }
      if (normalized == 'appointment') {
        return AppNotificationType.appointmentBooked;
      }

      for (final type in AppNotificationType.values) {
        if (type.name.toLowerCase() == normalized) {
          return type;
        }
      }
    }

    return AppNotificationType.unknown;
  }

  String? _extractNotificationTitle(RemoteMessage message) {
    final data = message.data;
    final type = _parseNotificationType(data['type']);
    final senderName = (data['senderName'] ?? data['userName'])?.toString().trim();
    final senderRole = data['senderRole']?.toString().toLowerCase();

    if (type.isChat && senderName != null && senderName.isNotEmpty) {
      if (senderRole == 'doctor' && !senderName.toLowerCase().startsWith('dr.')) {
        return 'Dr. $senderName';
      }
      return senderName;
    }

    return data['title']?.toString() ??
        data['notificationTitle']?.toString() ??
        message.notification?.title;
  }

  String? _extractNotificationBody(RemoteMessage message) {
    final data = message.data;
    final candidates = [
      data['message'],
      data['body'],
      data['content'],
      data['text'],
      data['notificationBody'],
      message.notification?.body,
    ];

    for (final candidate in candidates) {
      final text = candidate?.toString().trim();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }

    return null;
  }

  ConversationModel? _matchConversationFromData(
    List<ConversationModel> conversations,
    Map<String, dynamic> data,
  ) {
    ConversationModel? bestMatch;
    var bestScore = 0;

    for (final conversation in conversations) {
      final score = _conversationMatchScore(conversation, data);
      if (score > bestScore) {
        bestScore = score;
        bestMatch = conversation;
      }
    }

    return bestScore > 0 ? bestMatch : null;
  }

  int _conversationMatchScore(
    ConversationModel conversation,
    Map<String, dynamic> data,
  ) {
    var score = 0;
    final fallbackUserId = _parseInt(
      data['userId'] ??
          data['senderId'] ??
          data['chatUserId'] ??
          data['relatedEntityId'],
    );
    final senderName = (data['senderName'] ?? data['userName'])
        ?.toString()
        .trim()
        .toLowerCase();
    final normalizedConversationName = conversation.otherUserName
        .replaceFirst(RegExp(r'^dr\.\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
    final normalizedSenderName = senderName
        ?.replaceFirst(RegExp(r'^dr\.\s*', caseSensitive: false), '')
        .trim()
        .toLowerCase();
    final senderPicture =
        (data['senderProfilePicture'] ?? data['userProfilePicture'])
            ?.toString()
            .trim();
    final conversationPicture = conversation.otherUserProfilePicture?.trim();
    final messageText = _extractDataBody(data)?.toLowerCase() ?? '';
    final lastMessage = conversation.lastMessage.trim().toLowerCase();

    if (senderName != null && senderName.isNotEmpty) {
      if (conversation.otherUserName.trim().toLowerCase() == senderName) {
        score += 100;
      }
      if (normalizedSenderName != null &&
          normalizedConversationName == normalizedSenderName) {
        score += 90;
      }
    }

    if (senderPicture != null &&
        senderPicture.isNotEmpty &&
        conversationPicture != null &&
        conversationPicture.isNotEmpty &&
        senderPicture == conversationPicture) {
      score += 70;
    }

    if (!_isGenericChatText(messageText) &&
        lastMessage.isNotEmpty &&
        (lastMessage == messageText ||
            lastMessage.contains(messageText) ||
            messageText.contains(lastMessage))) {
      score += 50;
    }

    if (fallbackUserId != null && conversation.otherUserId == fallbackUserId) {
      score += senderName == null || senderName.isEmpty ? 40 : 15;
    }

    return score;
  }

  String? _extractDataBody(Map<String, dynamic> data) {
    final candidates = [
      data['message'],
      data['body'],
      data['content'],
      data['text'],
      data['notificationBody'],
    ];

    for (final candidate in candidates) {
      final text = candidate?.toString().trim();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }

    return null;
  }

  bool _isGenericChatText(String text) {
    final normalized = text.trim().toLowerCase();
    return normalized.isEmpty ||
        normalized == 'you received a new message' ||
        normalized == 'new message arrived' ||
        normalized == 'new message arrive' ||
        normalized == 'tap to continue the conversation';
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value > 0 ? value : null;
    final parsed = int.tryParse(value?.toString() ?? '');
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }

  bool _isChatPayload(Map<String, dynamic> data) =>
      data['senderId'] != null ||
      data['userId'] != null ||
      data['chatUserId'] != null ||
      (data['type']?.toString().toLowerCase().contains('chat') ?? false);

  Future<void> _ensureLocalNotificationsInitialized() async {
    if (_localNotificationsInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {
        await handleNotificationResponse(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _localNotificationsInitialized = true;
  }
}
