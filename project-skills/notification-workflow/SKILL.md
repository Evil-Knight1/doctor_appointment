---
name: notification-workflow
description: >
  Complete push notification workflow for the Doctor Appointment app —
  FCM setup, local notification display, deep-link routing, quick-reply
  from the notification tray, and background handling.
---

# Notification Workflow

## Overview

Notifications flow through **two channels** that work together:

1. **Firebase Cloud Messaging (FCM)** — delivers push messages from the
   backend to the device.
2. **`flutter_local_notifications`** — renders the notification in the
   system tray with rich UI (avatar, action buttons).

---

## Notification Types (`AppNotificationType`)

| Type | Routing behaviour |
|------|------------------|
| `chatMessage` | Opens `ChatScreen` for the sender |
| `appointmentBooked` | Fetches appointment list → opens `AppointmentDetailsView` |
| `appointmentApproved` | Same as above |
| `appointmentCancelled` | Same as above |
| `appointmentReminder` | Same as above |
| `paymentFailed` | Same as above |
| `doctorApproved` | Opens appointment details |
| `unknown` | Opens `NotificationView` |

---

## Initialisation Flow

```
main() / app startup
    │
    ▼
NotificationService.init()
    ├─ tz.initializeTimeZones()
    ├─ FCM.requestPermission(alert, badge, sound)
    ├─ _ensureLocalNotificationsInitialized()
    │      ├─ Android: channel "doctor_appointment_channel", Importance.max
    │      └─ iOS: DarwinCategories with reply/seen actions
    │
    ├─ FirebaseMessaging.onMessage         → showRemoteMessageNotification()
    ├─ FirebaseMessaging.onMessageOpenedApp → _navigateBasedOnData()
    └─ getInitialMessage()                  → _navigateBasedOnData()
```

After login, `UpdateFcmTokenUseCase` sends the device FCM token to
the backend so it knows where to push.

---

## Message Delivery Paths

### Foreground (app open)
```
FCM delivers → onMessage listener
    │
    ▼
showRemoteMessageNotification(fromBackground: false)
    ├─ Extract title & body from message.data or message.notification
    ├─ Parse notification type
    ├─ Load avatar bitmap (for chat messages)
    └─ _flutterLocalNotificationsPlugin.show()
           └─ Chat type → adds [Reply] + [Seen] action buttons
           └─ Other type → standard notification
```

### Background / Terminated
```
FCM delivers background message
    │
    ▼
handleBackgroundRemoteMessage() [top-level @pragma('vm:entry-point')]
    ├─ ensureBackgroundDependencies()
    │      ├─ loadEnv()
    │      ├─ SharedPreferencesHelper.init()
    │      └─ setupServiceLocator() (if not registered)
    └─ showRemoteMessageNotification(fromBackground: true)
           └─ If message has Notification block → skip (OS handles it)
           └─ Otherwise → show local notification
```

### Notification Tap (tray)
```
User taps notification
    │
    ▼
handleNotificationResponse(NotificationResponse)
    ├─ Decode JSON payload
    ├─ actionId == 'reply_action'
    │       ├─ _sendQuickReply()  → POST /api/Chat/send
    │       ├─ _markAsSeenFromPayload()
    │       └─ cancel tray notification
    ├─ actionId == 'seen_action'
    │       ├─ _markAsSeenFromPayload()
    │       └─ cancel tray notification
    └─ actionId == null (plain tap)
            └─ _navigateBasedOnData()
```

---

## Deep-Link Routing Logic

```dart
_navigateBasedOnData(data)
    ├─ type.isChat || senderId present
    │       └─ _openChatFromNotification()
    │              → router.push('/chat/:userId', extra: {name, avatar})
    │
    ├─ type.isAppointmentFlow || appointmentId present
    │       └─ _handleAppointmentTapAsync(appointmentId)
    │              → GetMyAppointmentsUseCase()
    │              → find appointment by id
    │              → router.push('/appointmentDetails', extra: appointment)
    │              → fallback: router.push('/calendar')
    │
    └─ else
            → router.push('/notifications')
```

---

## Quick-Reply from Tray (Android)

When a chat notification arrives, two action buttons appear:

| Button | Action |
|--------|--------|
| **Reply** | Inline text input → POST `/api/Chat/send` (background Dio) + mark read |
| **Seen** | PUT `/api/Chat/read/{userId}` (background Dio) + dismiss tray |

Background API calls use a **standalone Dio instance** authenticated
with the JWT token read from `SharedPreferences` (not GetIt, which may
not be available in a background isolate).

---

## Notification Colours by Type

| Type | Colour |
|------|--------|
| `appointmentApproved`, `doctorApproved` | `#4CAF50` (green) |
| `appointmentCancelled`, `paymentFailed` | `#F44336` (red) |
| `appointmentReminder` | `#FF9800` (orange) |
| All others | `#226CEB` (primary blue) |

---

## Key Files

| File | Role |
|------|------|
| `lib/core/services/notification_service.dart` | All notification logic (singleton) |
| `lib/features/home/domain/entities/app_notification_type.dart` | Notification type enum |
| `lib/features/home/data/datasource/notification_remote_data_source.dart` | Notification API calls |

---

## Important Notes

> **Background handler must be top-level.** The FCM background message
> handler is annotated with `@pragma('vm:entry-point')` and registered
> in `main.dart` via `FirebaseMessaging.onBackgroundMessage()`.

> **Notification with `notification` block + background:** iOS/Android
> OS handles these automatically. The app's handler skips them to avoid
> duplicates (`fromBackground=true && notification != null → return`).

> **FCM token refresh:** `NotificationService.onTokenRefresh` stream
> should be listened to and the new token sent to the backend.
