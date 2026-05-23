---
name: doctor-appointment-project
description: >
  High-level overview of the Doctor Appointment Flutter application —
  what it does, who it serves, and the key technology choices made.
---

# Project Summary

## What Is This App?

**Doctor Appointment** is a cross-platform mobile application (iOS & Android) built with Flutter that connects **patients** with **doctors**.

### User Roles

| Role | Capabilities |
|------|-------------|
| **Patient** | Search doctors · Book/cancel/reschedule appointments · Real-time chat with doctors · AI chatbot · Pay online (card / wallet / cash) · View medical records · Manage profile |
| **Doctor** | View dashboard statistics · Manage appointment schedule · Handle profile · Approve/reject reschedule requests |

---

## Technology Stack

### Frontend — Flutter

| Package | Purpose |
|---------|---------|
| `flutter_bloc` / Cubit | State management |
| `go_router` | Declarative navigation & deep linking |
| `get_it` | Dependency injection (Service Locator) |
| `dio` | HTTP client with interceptors |
| `signalr_core` | Real-time WebSocket chat (SignalR) |
| `firebase_messaging` | FCM push notifications |
| `flutter_local_notifications` | In-app notification display |
| `flutter_paymob` | Paymob payment gateway |
| `sentry_flutter` + `sentry_dio` | Crash & performance monitoring |
| `flutter_osm_plugin` | OpenStreetMap nearby-doctor map |
| `flutter_secure_storage` | Encrypted JWT storage |
| `flutter_dotenv` | `.env` environment config |
| `shorebird` | OTA code-push updates |

### Backend (External)

| Service | Technology |
|---------|-----------|
| REST API | C# ASP.NET Core WebAPI |
| Real-Time Messaging | ASP.NET Core SignalR |
| Authentication | JWT (access + refresh token) |
| Push Notifications | Firebase Cloud Messaging (FCM) |
| Payments | Paymob (MENA payment gateway) |
| Error Monitoring | Sentry |

---

## Feature Modules (16 total)

```
features/
├── auth/               # Login, register, OTP, forgot/reset password
├── home/               # Dashboard, OSM map, recommendations, notifications
├── doctors/            # Doctor listing, search, filter, reviews
├── doctor_details/     # Full doctor profile
├── doctor_flow/        # Doctor-only dashboard
├── appointment/        # Book, view history, cancel, reschedule
├── payments/           # Paymob checkout, history, status polling
├── chat/               # Real-time SignalR 1-on-1 messaging
├── chatbot/            # AI chat sessions
├── profile/            # Patient profile & avatar
├── medical_records/    # View & create records
├── favorite/           # Saved doctors
├── calendar/           # Appointment calendar
├── search/             # Doctor search
├── on_boarding_view/   # First-run carousel
└── splash/             # Session check & route redirect
```

---

## Platform & Version

- **Platform:** Flutter (iOS & Android)
- **Dart SDK:** ^3.10.7
- **App Version:** 1.0.0+3
- **Font:** Inter (Regular, Medium, Bold)
- **Localisation:** English & Arabic (`lib/l10n/`)
