---
name: doctor-appointment-architecture-and-patterns

description: >
  Architecture overview, data-flow diagram, design patterns, and core
  infrastructure decisions for the Doctor Appointment Flutter project.
---

# Project Architecture & Patterns

## Architecture: Clean Architecture + Feature-First

Every feature lives in its own self-contained folder inside `lib/features/`.
Each feature is divided into four layers:

```
features/<feature>/
├── data/
│   ├── datasources/   # HTTP (Dio/ApiService) or SignalR calls
│   ├── models/        # JSON serialisation / deserialisation (DTOs)
│   └── repositories/  # Implements domain repository interfaces
├── domain/
│   ├── entities/      # Pure Dart business objects (no framework deps)
│   ├── repositories/  # Abstract contracts
│   └── usecases/      # Single-responsibility business operations
├── logic/             # BLoC/Cubit — state management
└── presentation/ (or ui/)  # Views, widgets, screens
```

### Data Flow

```
UI (View)
  └─ dispatches event ──► Cubit
                             └─ calls UseCase
                                  └─ calls Repository (interface)
                                       └─ calls DataSource (Dio / SignalR)
                                            └─ hits REST API / WebSocket
```

---

## Core Patterns

### 1. Cubit (simplified BLoC)

- **Package:** `flutter_bloc ^9.1.1`
- Used for all state management — simpler than full BLoC for the
  loading / success / error pattern most screens need.
- Each Cubit is registered as a `registerFactory` in GetIt so every
  navigation creates a **fresh instance** (no stale state).

```dart
// Example: emit states
emit(PaymentLoading(message: 'Creating appointment…', amount: amount));
emit(PaymentSuccess(result: paymentResult));
emit(PaymentFailure(message: 'Payment failed', amount: amount));
```

### 2. GetIt — Service Locator (DI)

- **Package:** `get_it ^9.2.1`
- All services, repositories, use-cases, and cubits registered in
  `setupServiceLocator()` (`lib/core/services/service_locator.dart`).
- **Singletons** → stateless infrastructure (Dio, SecureStorage, repos).
- **Factories** → Cubits (fresh per navigation).
- Resolves dependencies anywhere without a `BuildContext`.

```dart
// Resolve anywhere:
final log = getIt<LogService>();
final useCase = getIt<GetMyAppointmentsUseCase>();
```

### 3. Result Type

- Use-cases and repositories return a `Result<T>` sealed class:
  - `Success<T>` — carries the data.
  - `FailureResult` — carries a `Failure` (ServerFailure, NetworkFailure, UnknownFailure).
- UI is **forced to handle both branches** before accessing the value.

```dart
final result = await _getPaymentStatusUseCase(appointmentId);
switch (result) {
  case FailureResult(): emit(PaymentFailure(...)); break;
  case Success():      doSomethingWith(result.data); break;
}
```

### 4. GoRouter — Navigation

- **Package:** `go_router ^17.1.0`
- Declarative routing with named routes in `AppRouter` constants.
- `BlocProvider` is scoped **per route** inside the builder, tying
  Cubit lifecycle to the page.
- Type-safe extras (e.g. `Doctor`, `AppointmentDraft`) passed via
  `state.extra`.

```dart
AppRouter.router.push(
  AppRouter.kAppointmentDetailsView,
  extra: appointment,
);
```

### 5. Dio + Interceptor Stack

Three interceptors in order:

1. **`AuthTokenInterceptor`** — attaches `Bearer` token; on 401 refreshes
   token via a `Completer` lock (prevents parallel refresh calls), then
   retries the original request.
2. **`ApiLoggingInterceptor`** — structured request/response logging via
   `LogService`.
3. **`SentryDio`** — auto-captures HTTP errors to Sentry with full context.

Timeouts: connect / receive / send all **5 seconds**.

### 6. Errors & Failures

```
DataSource layer   throws  ApiException  (message, statusCode, fieldErrors)
                                ↓
Repository layer   catches  ApiException → wraps in Failure subclass
                                ↓
Domain / UI        receives Failure (ServerFailure / NetworkFailure / UnknownFailure)
```

---

## Core Infrastructure Summary

| Component | Location | Notes |
|-----------|----------|-------|
| DI wiring | `lib/core/services/service_locator.dart` | All registrations |
| HTTP client | `lib/core/services/api_service.dart` | Dio wrapper |
| Token refresh | `lib/core/services/auth_token_interceptor.dart` | Proactive + reactive |
| Routing | `lib/core/utils/go_router.dart` | All named routes |
| Notifications | `lib/core/services/notification_service.dart` | FCM + Local |
| Logging | `lib/core/logging/log_service.dart` | Structured logs |
| Theme | `lib/core/utils/app_theme.dart` | Light/Dark |
| Localisation | `lib/l10n/` | EN + AR ARB files |
| Environment | `assets/envs/.env` | Loaded via `flutter_dotenv` |
| Error monitoring | Sentry (init in `main.dart`) | 100% sample rate (dev) |

---

## Auth Flow

```
Splash → check cached session
  ├─ valid token     → /root          (patient home)
  ├─ valid token     → /doctorRoot    (doctor home)
  ├─ no token        → /onBoardingView → /userSelectionView
  └─ pending doc     → /doctorPendingApprovalView
```

JWT stored in `FlutterSecureStorage`.  
Dual user roots (`/root` vs `/doctorRoot`) keep patient and doctor UX
fully independent.

---

## Key Architecture Decisions

| Decision | Rationale |
|----------|-----------|
| Clean Architecture | Testability; domain layer has zero Flutter dependency |
| Cubit over full BLoC | Reduces boilerplate; sufficient for loading/success/error states |
| GetIt over Provider DI | Context-free resolution; wiring all in one auditable place |
| GoRouter | Deep linking support; named routes prevent typos |
| SignalR over raw WebSocket | Backend is ASP.NET Core; automatic reconnection & hub methods |
| OSM over Google Maps | No billing required; reduces setup complexity |
| Factory registration for Cubits | Fresh state per navigation; singletons for infrastructure only |
| Separate patient/doctor roots | Two roles have fundamentally different UX; avoids complex conditionals |
| Shorebird OTA | Ship Dart patches without App Store/Play Store review |
