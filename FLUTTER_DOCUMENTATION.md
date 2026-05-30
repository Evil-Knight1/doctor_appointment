# MedLink — Flutter Mobile Application Documentation

> **Graduation Project Documentation**  
> App Name: MedLink | Package: `doctor_appointment`  
> Version: 1.0.0+3 | Dart SDK: ^3.10.7 | Flutter: Material 3

---

## Table of Contents

1. [Flutter Packages & Libraries](#1-flutter-packages--libraries)
2. [Screen Structure & Navigation](#2-screen-structure--navigation)
3. [Backend Communication & API Calls](#3-backend-communication--api-calls)
4. [User Authentication & Session Management](#4-user-authentication--session-management)
5. [Appointment Booking Flow](#5-appointment-booking-flow)
6. [AI Chatbot UI Integration](#6-ai-chatbot-ui-integration)
7. [UI/UX Design Decisions](#7-uiux-design-decisions)
8. [State Management](#8-state-management)
9. [Testing](#9-testing)
10. [Notable Technical Challenges](#10-notable-technical-challenges)

---

## 1. Flutter Packages & Libraries

### Core Networking

| Package | Version | Purpose |
|---|---|---|
| `dio` | ^5.9.2 | Primary HTTP client. Used for all REST API calls with interceptor support (auth headers, token refresh, logging). |
| `sentry_dio` | ^9.19.0 | Dio integration for Sentry — automatically captures HTTP errors and attaches them to error events. |
| `signalr_core` | ^1.1.2 | ASP.NET SignalR client for real-time bi-directional doctor–patient chat. Manages WebSocket hub connections. |

### Authentication & Secure Storage

| Package | Version | Purpose |
|---|---|---|
| `flutter_secure_storage` | ^10.0.0 | Encrypted key-value store (uses Android Keystore / iOS Keychain). Stores JWT token, refresh token, user ID, role, and expiry. |
| `shared_preferences` | ^2.5.5 | Lightweight key-value store for non-sensitive data: onboarding flag, theme mode, locale preference, token quick-access copy, and favorite doctors list. |
| `jwt_decoder` | ^2.0.1 | Decodes and inspects JWT tokens client-side (e.g., checking expiry on app startup). |

### State Management & Dependency Injection

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^9.1.1 | BLoC/Cubit pattern for all feature-level state management. Every feature has one or more Cubits. |
| `get_it` | ^9.2.1 | Service locator / dependency injection container. All singletons and factories are registered in `setupServiceLocator()`. |
| `equatable` | ^2.0.8 | Value equality for Dart objects, used in BLoC states and entities to simplify `==` comparisons. |

### Routing

| Package | Version | Purpose |
|---|---|---|
| `go_router` | ^17.1.0 | Declarative, URL-based routing. Manages all named routes and handles passing typed objects through `state.extra`. |

### UI & Layout

| Package | Version | Purpose |
|---|---|---|
| `flutter_screenutil` | ^5.9.3 | Adaptive screen sizing. Converts px-based sizes to relative units (`.sp`, `.w`, `.h`, `.r`) based on a 375×812 design canvas. |
| `responsive_framework` | ^1.5.1 | Provides breakpoints (MOBILE ≤ 450, TABLET ≤ 800, DESKTOP ≤ 1920) and `ResponsiveScaledBox` for web/tablet layouts. |
| `flex_seed_scheme` | ^4.0.1 | Generates Material 3 `ColorScheme` from seed colors with vivid tone customization. Powers the complete theme system. |
| `flutter_svg` | ^2.2.4 | Renders SVG assets throughout the app (icons, illustrations). |
| `cached_network_image` | ^3.4.1 | Caches remote images to disk and memory, used for doctor profile pictures and clinic photos. |
| `photo_view` | ^0.15.0 | Pinch-to-zoom image viewer used for clinic images in doctor details. |
| `font_awesome_flutter` | ^11.0.0 | Extended icon set for specialty icons and UI accents. |
| `iconsax_flutter` | ^1.0.1 | Isax icon pack used throughout the navigation bar and feature screens. |
| `skeletonizer` | ^2.1.3 | Skeleton loading animation that shimmers over real widget trees while data is fetching. |
| `liquid_pull_to_refresh` | ^3.0.1 | Animated pull-to-refresh widget with a liquid animation effect. |
| `curved_labeled_navigation_bar` | ^2.0.6 | Bottom navigation bar with curved active-item indicator and labels. |
| `flutter_spinkit` | ^5.2.2 | Collection of animated loading spinners used in full-screen loading states. |
| `device_preview` | ^1.3.1 | Development tool to preview the app on different device sizes and form factors (disabled in production). |

### Forms & Input

| Package | Version | Purpose |
|---|---|---|
| `phone_form_field` | ^10.0.17 | International phone number input with country-code picker and validation. |
| `pinput` | ^6.0.2 | Styled OTP/PIN input field used in the OTP verification screen (forgot password flow). |
| `image_picker` | ^1.1.2 | Camera and gallery access for profile photo and clinic image uploads. |
| `file_picker` | ^11.0.2 | File browser for selecting medical record documents (PDFs, images). |

### Calendar & Date Handling

| Package | Version | Purpose |
|---|---|---|
| `table_calendar` | ^3.2.0 | Rich interactive calendar widget used in the booking date selection screen. Shows availability dots on days with slots. |
| `intl` | any | Internationalization, date formatting (e.g., `DateFormat('hh:mm a')`), and locale-aware number formatting. |

### Maps & Location

| Package | Version | Purpose |
|---|---|---|
| `geolocator` | ^14.0.2 | Gets device GPS coordinates for the "Find Nearby Doctors" feature. |
| `geocoding` | ^4.0.0 | Converts coordinates to human-readable addresses and vice versa. |
| `flutter_osm_plugin` | ^1.1.0 | OpenStreetMap-based map widget to display nearby doctors on an interactive map. |
| `map_launcher` | ^4.5.0 | Launches native map apps (Google Maps, Apple Maps, Waze) with a deep-link to a doctor's clinic location. |

### Payments

| Package | Version | Purpose |
|---|---|---|
| `flutter_paymob` | ^1.0.8 | Paymob payment gateway SDK for Egypt. Handles credit card and mobile wallet (Vodafone Cash, etc.) payments via in-app WebView. |
| `webview_flutter` | ^4.13.1 | Renders the Paymob payment iframe inside the app without opening an external browser. |

### Push Notifications

| Package | Version | Purpose |
|---|---|---|
| `firebase_core` | ^4.9.0 | Firebase SDK core — required to initialize the Firebase app before using other Firebase services. |
| `firebase_messaging` | ^16.2.2 | Firebase Cloud Messaging (FCM) for push notifications. Handles foreground, background, and terminated-state notification delivery. |
| `flutter_local_notifications` | ^21.0.0 | Displays local notification banners (foreground notifications from FCM) with custom channels and sounds. |
| `timezone` | ^0.11.0 | Time zone database required by `flutter_local_notifications` for scheduled notifications. |

### Caching & Offline Support

| Package | Version | Purpose |
|---|---|---|
| `hive` | ^2.2.3 | Fast, lightweight NoSQL database stored locally. Used to cache chat messages and conversations (`ChatCacheService`) and profile/appointment data (`AppCacheService`). |
| `hive_flutter` | ^1.1.0 | Hive adapter for Flutter — initializes Hive boxes using `path_provider`. |
| `api_cache_manager` | ^1.0.2 | HTTP response caching layer to reduce redundant API calls. |
| `flutter_offline` | ^6.0.0 | Monitors internet connectivity and shows an "No Internet Connection" banner at the top of the screen when offline. |
| `path_provider` | ^2.1.5 | Provides platform-specific file system paths for Hive and local file storage. |

### Monitoring & Logging

| Package | Version | Purpose |
|---|---|---|
| `sentry_flutter` | ^9.19.0 | Crash and error reporting SDK. Wraps `main()` to capture uncaught exceptions, performance traces, and profiles. |
| `logger` | ^2.7.0 | Structured console logging with colored output and log levels (debug, info, warning, error). |

### Localization

| Package | Version | Purpose |
|---|---|---|
| `flutter_localizations` (SDK) | — | Flutter's built-in localization support (required for multi-language apps). |
| `intl` | any | ARB-based localization message catalog. Generated `AppLocalizations` class is used throughout the app. |

### URL & Deep Links

| Package | Version | Purpose |
|---|---|---|
| `url_launcher` | ^6.3.2 | Opens external URLs in the browser (e.g., terms and conditions, clinic website links). |

### Build & CI

| Package | Version | Purpose |
|---|---|---|
| `flutter_launcher_icons` | ^0.14.3 | Generates Android and iOS launcher icons from a single source image. |

---

## 2. Screen Structure & Navigation

The app uses **GoRouter** for declarative, URL-based navigation. There are two root shells:
- **Patient root** (`/root`) — bottom navigation bar with tabs for Home, Calendar, Chat, and Profile.
- **Doctor root** (`/doctorRoot`) — separate bottom navigation for the doctor's dashboard.

### Navigation Entry Points

```
SplashView (/) 
  ├── OnBoardingView          (first launch)
  ├── LoginView               (unauthenticated)
  └── Root  OR  DoctorRoot    (authenticated, by role)
```

---

### Authentication Screens

| Screen | Route | Description |
|---|---|---|
| **SplashView** | `/` | Launched on app start. Checks onboarding flag, validates cached session, proactively refreshes the JWT, then routes to the correct shell based on user role. |
| **OnBoardingView** | `/onBoardingView` | Three-page introductory carousel shown only on first launch. Marked as "seen" in SharedPreferences on completion. |
| **UserSelectionView** | `/userSelectionView` | Role picker — user selects "Patient" or "Doctor" before signing up. |
| **LoginView** | `/loginView` | Email + password login form with field validation and BLoC-driven loading/error states. |
| **SignUpView** | `/signUpView` | Patient registration form: full name, email, phone (international picker), password, optional DOB, gender, profile photo. |
| **DoctorSignUpView** | `/doctorSignUpView` | Extended doctor registration: includes all patient fields plus specialization dropdown (from API), years of experience, license ID, clinic address, hospital name, consultation fee, bio, and clinic photo gallery. |
| **ForgotPasswordView** | `/forgotPasswordView` | Email entry screen to initiate the password reset flow. |
| **VerifyOtpView** | `/verifyOtpView` | 6-digit OTP verification screen using Pinput. Receives the email as a route argument. |
| **ResetPasswordView** | `/resetPasswordView` | New password entry. Receives email and OTP token as route arguments. |
| **DoctorPendingApprovalView** | `/doctorPendingApprovalView` | Shown to newly registered doctors whose accounts are awaiting admin review. |

---

### Patient Shell — Bottom Navigation Tabs

The `Root` widget hosts a bottom navigation bar with four tabs:

| Tab | Screen | Description |
|---|---|---|
| 🏠 Home | **HomeView** | Dashboard showing a greeting, top-rated doctors list (cards with hero animations), speciality shortcuts, and quick-access actions (Find Nearby, Recommendations, Chatbot). |
| 📅 Calendar | **CalendarView** | Lists the patient's upcoming and past appointments. Uses a custom calendar view and appointment status badges (Pending, Confirmed, Cancelled). |
| 💬 Chat | **ConversationsScreen** | Real-time patient–doctor messaging. Lists all active conversations with last-message preview. |
| 👤 Profile | **ProfileView** | Shows patient's name, photo, and quick-access menu: Edit Profile, Payment History, Medical Records, AI Chat History, Favorites, Settings (theme + language toggle), and Logout. |

---

### Home Sub-Screens (Patient)

| Screen | Route | Navigation Trigger |
|---|---|---|
| **NotificationsView** | `/notificationView` | Bell icon in HomeView AppBar |
| **FindNearbyView** | `/findNearbyView` | "Nearby" card on home / map FAB |
| **DoctorSpecialityView** | `/doctorSpecialityView` | "All Specialties" button on home |
| **RecommendationView** | `/recommendationView` | Specialty chip → filters doctors by specialization ID |
| **DoctorDetailsView** | `/homeDoctorDetailsView` | Tapping a doctor card (passes `HomeDoctorModel` + hero tag) |
| **SearchView** | Accessed via search icon | Search bar with live doctor search |
| **FavoriteView** | `/favoriteView` | Accessible from Profile |

---

### Booking Flow Screens

These screens form the linear booking wizard (detailed in Section 5):

| Screen | Route | Step |
|---|---|---|
| **BookingDateView** | `/bookingDateView` | Step 1 — Date & time slot selection |
| **BookingPaymentView** | `/bookingPaymentView` | Step 2 — Appointment type & reason entry |
| **BookingSummaryView** | `/bookingSummaryView` | Step 3 — Full booking summary |
| **CheckoutView** | `/checkoutView` | Step 4 — Payment method selection |
| **PaymentStatusView** | `/paymentStatusView` | Payment result polling |
| **BookingConfirmedView** | `/bookingConfirmedView` | Booking success confirmation |
| **BookingReviewView** | `/bookingReviewView` | Post-appointment doctor review & rating |

---

### Appointment Management Screens

| Screen | Route | Description |
|---|---|---|
| **AppointmentDetailsView** | `/appointmentDetailsView` | Full details of a single appointment (status, doctor info, date, payment). Actions: cancel, request reschedule. Works for both patient and doctor flows via `isDoctorFlow` flag. |
| **NewAppointmentView** | `/newAppointment` | Legacy booking entry (from search-result doctors). |
| **PatientDetailsView** | `/patientDetails` | Reason-for-visit and patient note entry in the old booking flow. |
| **AppointmentSuccessView** | `/appointmentSuccess` | Cash payment confirmation screen. |

---

### Chatbot & Chat Screens

| Screen | Route | Description |
|---|---|---|
| **ChatbotView** | `/chatbotView` | AI symptom-checker chatbot. Can resume a previous session by passing a `sessionId`. |
| **ChatHistoryView** | `/chatHistoryView` | List of all past AI chat sessions with timestamps. Tap to reopen a session. |
| **ConversationsScreen** | `/conversationsView` | List of real-time chat conversations with doctors. |
| **ChatScreen** | `/chat/:userId` | Individual doctor–patient real-time chat via SignalR. |

---

### Profile & User Screens

| Screen | Route | Description |
|---|---|---|
| **ProfileView** | `/profileView` | Patient profile hub with avatar, stats, and settings menu. |
| **EditProfileView** | `/editProfileView` | Editable form for name, phone, DOB, gender, address, and profile photo. |
| **MedicalRecordsView** | `/medicalRecordsView` | Lists the patient's uploaded medical documents. |
| **CreateRecordView** | `/createRecordView` | File picker form to upload a new medical record (name + file). |

---

### Payment Screens

| Screen | Route | Description |
|---|---|---|
| **PaymentHistoryView** | `/paymentHistoryView` | Chronological list of all payment transactions with status badges. |
| **TransactionDetailsView** | `/transactionDetailsView` | Detailed receipt for a single payment. |
| **PaymentWebViewScreen** | (Navigator push) | Embedded Paymob payment iframe (WebView). Not a named GoRouter route. |

---

### Doctor Dashboard Screens

The Doctor root (`/doctorRoot`) is a separate shell with its own navigation:

| Screen | Description |
|---|---|
| **Doctor Dashboard** | Stats overview: total patients, total appointments, revenue charts (monthly/daily bar charts). |
| **Doctor Appointments** | List of all assigned appointments with status management (Confirm, Complete, Reject). Reschedule approval workflow. |
| **Doctor Profile** | Doctor's own profile with edit capability (bio, clinic address, consultation fee, availability settings). |
| **Doctor Availability** | Weekly schedule management — set working hours per day of the week. |

---

## 3. Backend Communication & API Calls

### HTTP Client Setup

All API communication uses **Dio** configured as a lazy singleton in `service_locator.dart`:

```dart
getIt.registerLazySingleton<Dio>(
  () => Dio(BaseOptions(
    baseUrl: getIt<AppConfig>().apiUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    receiveDataWhenStatusError: true,
  )),
);
```

### Interceptors

Two interceptors are attached to the Dio instance in order:

1. **`AuthTokenInterceptor`** — injected before every request:
   - Reads the latest JWT from `SharedPreferences` (fast path) or `FlutterSecureStorage`.
   - Adds `Authorization: Bearer <token>` header.
   - Reads the saved locale and adds `Accept-Language: en|ar` header.
   - On a `401 Unauthorized` response: triggers a token refresh against `/api/Auth/refresh`. All concurrent 401 requests are queued on a `Completer<void>` to prevent duplicate refresh calls. If the refresh succeeds, the original request is retried. If it fails, the user is redirected to the login screen.

2. **`ApiLoggingInterceptor`** — logs request/response details via `LogService` for debugging.

3. **Sentry Dio** (`getIt<Dio>().addSentry()`) — auto-captures HTTP errors as Sentry breadcrumbs.

### Service Layer

An abstract `ApiService` interface wraps Dio with four methods:

```dart
abstract class ApiService {
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String endpoint, {Object? data});
  Future<dynamic> put(String endpoint, {Object? data});
  Future<dynamic> delete(String endpoint, {Object? data});
}
```

Each feature's **Remote Data Source** takes an `ApiService` and calls its methods. For example:

```
DoctorsRemoteDataSource → ApiService.get('/api/Doctors')
AppointmentRemoteDataSource → ApiService.post('/api/Appointments')
AIChatRemoteDataSource → ApiService.post('/api/AIChat/send')
```

### Clean Architecture Data Flow

```
UI (View)
  └── Cubit / BLoC  ──calls──▶  UseCase
                                    └── Repository (interface)
                                              └── RemoteDataSource
                                                        └── ApiService (Dio)
                                                                  └── Backend REST API
```

Errors are wrapped in a `Result<T>` type (`Success<T>` | `FailureResult<T>`) so Cubits handle success and failure paths without try-catch in the UI.

### Real-Time Chat (SignalR)

The doctor–patient chat uses **ASP.NET SignalR** via `signalr_core`:

```dart
_connection = HubConnectionBuilder()
    .withUrl(hubUrl, HttpConnectionOptions(
      accessTokenFactory: () async => session.token,
    ))
    .withAutomaticReconnect()
    .build();
```

Events listened:
- `ReceiveMessage` / `MessageSent` → stream new messages to the UI.
- `MessagesRead` / `MessageRead` → propagate read receipts.
- `Error` → surfaces connection errors to the UI.

---

## 4. User Authentication & Session Management

### Registration

Two registration paths exist:
- **Patient** (`AuthCubit.registerPatient`) — submits multipart form data including an optional profile image.
- **Doctor** (`AuthCubit.registerDoctor`) — additionally requires specialization ID, experience years, license ID, clinic details, consultation fee, bio, and multiple clinic images.

After successful registration, the `AuthResponse` (JWT token, refresh token, user ID, role, expiry) is persisted and the FCM device token is sent to the backend.

### Login

`AuthCubit.login(email, password)` calls `LoginUseCase` → `AuthRemoteDataSource.login()` → `POST /api/Auth/login`.

On success, two persistence layers are updated:
1. **`FlutterSecureStorage`** (via `AuthLocalDataSourceImpl`): stores `auth_token`, `auth_refresh_token`, `auth_email`, `auth_role`, `auth_user_id`, `auth_expires_at` — encrypted at rest.
2. **`SharedPreferences`**: stores the token string for quick synchronous access (used by the Dio interceptor to avoid async overhead on every request) and a JSON blob (`user_data`) with role information.

### Session Persistence & Auto-Login

On every cold start, `SplashView._handleStartup()` executes:

```
1. Check if onboarding was seen → redirect to onboarding if not.
2. Load cached session from FlutterSecureStorage.
3. Attempt a proactive token refresh (POST /api/Auth/refresh).
   a. If refresh succeeds → persist new tokens and continue.
   b. If refresh fails BUT cached JWT is still valid → proceed anyway 
      (the Dio interceptor will handle any subsequent 401).
   c. If refresh fails AND JWT is expired → redirect to login.
4. Route to /root (patient) or /doctorRoot (doctor) based on role.
```

### Token Refresh Strategy

The `AuthTokenInterceptor` implements a **single-flight refresh** pattern:
- A boolean `_isRefreshing` guard and a `Completer<void>? _refreshCompleter` ensure that only one refresh call is made even if multiple requests fail with 401 simultaneously.
- All other failed requests await `_refreshCompleter.future`, then retry with the new token.

### Forgot Password Flow

1. User enters email → `ForgotPasswordCubit.sendForgotPasswordEmail()` → `POST /api/Auth/forgot-password`.
2. OTP code received by email → `VerifyOtpView` → `ForgotPasswordCubit.verifyOtp()`.
3. Token returned → `ResetPasswordView` → `ForgotPasswordCubit.resetPassword()`.

### Logout

On logout (from Profile screen):
- `SharedPreferencesHelper.removeToken()` and `removeUserData()` clear the SharedPreferences layer.
- `AuthLocalDataSourceImpl.clearSession()` deletes all keys from FlutterSecureStorage.
- `GoRouter.go('/loginView')` redirects immediately.

---

## 5. Appointment Booking Flow

The booking flow is a **4-step wizard** with a `BookingStepper` progress indicator displayed at the top of each step screen.

### Step 1 — Date & Time Selection (`BookingDateView`)

**Entered via:** Doctor Details screen → "Book Appointment" button (passes `Doctor` entity).

1. The `DoctorSlotsCubit` fetches available time slots for the doctor for today's date via `GET /api/Doctors/{id}/slots?date=...`.
2. A **`TableCalendar`** widget displays the current month. Days that have available slots are marked with a primary-color dot.
3. Tapping a date re-fetches slots and populates three time-of-day groups: **Morning** (before 12:00), **Afternoon** (12:00–17:00), **Evening** (after 17:00).
4. Selecting a slot highlights it with the primary color. Booked/unavailable slots are shown as dimmed with a strikethrough.
5. The user also selects the appointment **type**: Regular Visit or Consultation (animated selection cards).
6. Tapping "Next" navigates to Step 2, passing `{ doctor, date, time, slotId, amount, type }` as route extras.

> **Reschedule path:** If `rescheduleAppointmentId` is provided, Step 2 (payment) is skipped and the user goes directly to the Booking Summary.

---

### Step 2 — Reason for Visit (`BookingPaymentView`)

1. The user enters a **reason for visit** in a text field.
2. The selected date, time, doctor name, and consultation fee are shown as a summary card.
3. Tapping "Continue" navigates to the Booking Summary (Step 3).

---

### Step 3 — Booking Summary (`BookingSummaryView`)

1. A complete summary is displayed: doctor info, specialty, date, time slot, appointment type, reason, and total amount.
2. For online payment: tapping "Confirm" navigates to the **Checkout** screen (Step 4).
3. For reschedule requests: tapping "Confirm" calls the reschedule API directly and shows the confirmed screen.

---

### Step 4 — Payment (`CheckoutView`)

Three payment methods are available (selected via animated radio tiles):

| Method | Flow |
|---|---|
| **Credit/Debit Card** | `PaymentCubit.checkout()` → `POST /api/Payments/create-session` → backend returns a Paymob payment URL → opens `PaymentWebViewScreen` (in-app iframe) |
| **Mobile Wallet** | Same flow but with wallet integration ID |
| **Cash at Clinic** | Creates the appointment directly with payment method = cash → navigates to `AppointmentSuccessView` |

### Payment Status Verification (`PaymentStatusView`)

After the WebView completes, the app navigates to `PaymentStatusView`, which polls `GET /api/Payments/status/{appointmentId}` until it receives a definitive `Success` or `Failed` result.

---

### Booking Confirmation (`BookingConfirmedView`)

Displays a success animation, appointment summary, and options to:
- View appointment details.
- Leave a review for the doctor.
- Return to the home screen.

---

## 6. AI Chatbot UI Integration

### Overview

The chatbot feature (powered by a backend AI service) provides a **symptom-checking assistant** that guides users through their symptoms via a structured conversation, then optionally recommends doctors.

### Screen: `ChatbotView`

The view is a `StatefulWidget` driven by `ChatCubit`. On route entry, `ChatCubit.initChat(sessionId?)` is called:
- If `sessionId == null`: starts a fresh session (`POST /api/AIChat/start`) and receives a welcome message.
- If `sessionId != null`: loads the historical messages (`GET /api/AIChat/{sessionId}/history`).

### Conversation Display

Messages are rendered in a `ListView.separated` with two bubble styles:

- **User message** (right-aligned): Blue bubble with `onPrimary` text, rounded top-left/right and bottom-left corners.
- **Bot message** (left-aligned): Surface-container bubble with rounded top corners and bottom-right corner. A **colored border** (green/orange/red) is added to the last AI message based on the `riskLevel` field returned by the API (`LOW` / `MEDIUM` / `HIGH` / `EMERGENCY`).

A "typing" indicator (`...` bubble) appears in the list when `ChatStatus.sending`.

### Dynamic Input Components

The AI response includes a `UiComponent` field that dictates what input to render:

| `ui.type` | Widget Rendered | Description |
|---|---|---|
| `"text"` or `null` | `TextField` + Send button | Free-form text input |
| `"radio"` | `ChatbotRadioSelector` | Single-choice option list; "Other" option switches back to text input |
| `"checkbox"` | `ChatbotCheckboxSelector` | Multi-select option list; submits as comma-separated string |

### Doctor Recommendation Integration

When the AI detects a doctor-search intent, the response type is `"get_doctors"`. The `ChatCubit` handles this transparently:

1. Parses `response.searchParams` (specialization name, location, min rating).
2. Calls `GetSpecializationsUseCase` to match the specialization name to an ID.
3. Calls `SearchDoctorsUseCase` with the extracted parameters.
4. Packages the result as a tool call payload and sends it back to the AI (`POST /api/AIChat/send` with `toolResult`).
5. The AI's final response (now with doctors list embedded) is displayed as a normal bot message.

### Chat History (`ChatHistoryView`)

Lists all past AI sessions with session date. Tapping a session navigates to `ChatbotView` with the `sessionId`, restoring the full conversation.

### Rate Limiting

If the backend returns a limit-exceeded error, `ChatCubit` emits `ChatStatus.limitReached`. The UI disables the input and shows a `GlassAlert` overlay notification.

---

## 7. UI/UX Design Decisions

### Color System

The palette is defined in `AppColors` and seeded into the Material 3 `ColorScheme` using `flex_seed_scheme` with `FlexTones.vivid`:

| Role | Light Value | Hex |
|---|---|---|
| Primary | Royal Blue | `#247CFF` |
| Secondary / Success | Emerald Green | `#10B981` |
| Accent / Error | Red | `#EF4444` |
| Warning | Amber | `#F59E0B` |
| Pending | Indigo | `#6366F1` |
| Header Gradient Start | Blue | `#2563EB` |
| Header Gradient End | Dark Blue | `#1D4ED8` |
| Dark Background | Slate 950 | `#0F172A` |
| Dark Surface | Slate 800 | `#1E293B` |

### Dark Mode

Full light/dark mode support driven by `ThemeCubit`. Theme mode (light/dark/system) is persisted in `SharedPreferences` under `theme_mode`. The `AppTheme._buildTheme(Brightness)` method builds both themes from the same seed colors, adjusting surfaces, fills, and shadows for each mode.

### Typography

The app uses the **Inter** font family (bundled as assets: Regular, Medium, Bold weights) across all text styles. The `TextTheme` is fully customized in `AppTheme._textTheme()`:

| Style | Size | Weight | Usage |
|---|---|---|---|
| `displayLarge` | 32sp | Bold | Major headings |
| `headlineLarge` | 24sp | Bold | Section headings |
| `titleLarge` | 18sp | 700 | App bar titles |
| `titleMedium` | 16sp | 600 | Card titles |
| `bodyLarge` | 16sp | 400 | Primary body text |
| `bodyMedium` | 14sp | 400 | Secondary body text |
| `bodySmall` | 12sp | 400 | Captions, hints |
| `labelLarge` | 14sp | 600 | Button labels |

All sizes use `.sp` units from `flutter_screenutil` to scale relative to the 375px design width.

### Layout Principles

1. **Responsive Design**: The app runs on mobile, tablet, and desktop (web). `ResponsiveFramework` defines breakpoints, and key screens (e.g., `BookingDateView`) switch between single-column and two-column layouts when `maxWidth > 700`.
2. **Design Size**: `ScreenUtilInit` uses 375×812 for mobile. On desktop, the design size is set to the actual window size so scaling is disabled (scale factor = 1.0).
3. **Maximum Card Width**: Bottom sheets are constrained to `maxWidth: 450` to avoid overly wide modals on tablets/desktops.
4. **Spacing System**: Standardized spacing constants (`AppSpacing.xs`, `sm`, `md`, `lg`, `xl`, `xxl`) and border radii (`AppRadius.sm`, `md`, `lg`, `xl`) ensure visual consistency.

### Micro-Animations

- **`AnimatedContainer`** on booking type cards and payment method tiles — smoothly transitions color, border, and shadow when selected (`250ms`, `Curves.easeInOut`).
- **Hero animations** on doctor cards between the home list and the doctor details screen.
- **Skeleton loading** (`Skeletonizer`) instead of spinners for list items and time-slot grids.
- **Scroll-to-bottom animation** in chat views (`Curves.easeOut`, 300ms).

### Component System

The `AppTheme` defines globally consistent styles for:
- **Buttons**: 12px radius, 14px horizontal padding, `600` weight. `ElevatedButton` uses primary background; `OutlinedButton` uses primary border.
- **Input Fields**: Filled, 12px radius, `outlineVariant` border, `primary` border on focus.
- **Cards**: `surfaceContainerLow` background, 16px radius, `outlineVariant` border (1px on light, 0.5px on dark).
- **Dialogs**: 24px radius, `surface` background.
- **Chips**: 8px radius, `surfaceContainerLow` background.

### Offline Banner

A persistent red banner ("No Internet Connection") slides in at the top of all screens when connectivity is lost, using `flutter_offline`'s `OfflineBuilder` wrapped around the entire app.

### Localization

The app is fully bilingual (English/Arabic), driven by ARB files and the generated `AppLocalizations` class. The locale is managed by `LocaleCubit` and persisted in SharedPreferences under `language_code`. The Dio interceptor reads this key to set the `Accept-Language` header on all API requests, so the backend serves localized responses.

---

## 8. State Management

### Pattern: BLoC / Cubit

The app uses **Flutter BLoC** exclusively. **Cubits** (a simpler subset of BLoC without events) are used for all features since the state transitions are linear and don't require event-driven architecture.

### Dependency Injection: GetIt

All Cubits, repositories, use cases, and services are registered in `setupServiceLocator()` (`service_locator.dart`) using **GetIt**:

- **`registerLazySingleton`**: Services and repositories — created once on first access (e.g., `Dio`, `ApiService`, `AuthLocalDataSource`).
- **`registerFactory`**: Cubits — a **new instance is created each time** a route is pushed, preventing stale state between navigations (e.g., `AuthCubit`, `DoctorDetailsCubit`, `PaymentCubit`).

### Cubit Inventory

| Cubit | Scope | Responsibility |
|---|---|---|
| `ThemeCubit` | App-level singleton | Manages light/dark/system theme mode |
| `LocaleCubit` | App-level singleton | Manages en/ar locale |
| `AuthCubit` | Per-route factory | Login, register (patient & doctor), availability check |
| `ForgotPasswordCubit` | Per-route factory | Forgot password OTP flow |
| `DoctorsCubit` | Per-route factory | Fetches and searches the doctor list |
| `DoctorDetailsCubit` | Per-route factory | Loads doctor details, reviews, and ratings |
| `SpecializationsCubit` | Per-route factory | Fetches specialization list |
| `DoctorSlotsCubit` | Per-route factory | Fetches available booking slots for a doctor |
| `AppointmentCubit` | Per-route factory | Creates a single appointment |
| `AppointmentsCubit` | Root + per-route | Loads/manages patient's appointment list; cancel/reschedule |
| `ProfileCubit` | Root + per-route | Loads and updates patient profile; uses `AppCacheService` |
| `PaymentCubit` | Per-route factory | Creates payment session, verifies status, handles cash flow |
| `PaymentHistoryCubit` | Per-route factory | Fetches transaction history |
| `ChatCubit` (AI) | Per-route factory | Manages AI chatbot session, message send/receive |
| `ChatHistoryCubit` | Per-route factory | Fetches list of past AI chat sessions |
| `UserChatCubit` | Per-route factory | Manages individual SignalR doctor–patient chat |
| `ConversationsCubit` | Per-route factory | Lists all chat conversations |
| `NotificationCubit` | Per-route factory | Fetches in-app notifications list |
| `DoctorStatsCubit` | Doctor root | Doctor dashboard statistics |
| `DoctorAppointmentsCubit` | Doctor root | Doctor's appointment list with status management |
| `DoctorProfileCubit` | Doctor root | Doctor's own profile view and edit |
| `DoctorRevenueCubit` | Doctor root | Monthly and daily revenue chart data |
| `DoctorAvailabilityCubit` | Doctor root | Doctor's weekly availability schedule |

### Global BLoC Provisioning

App-level Cubits (`ThemeCubit`, `LocaleCubit`) are provided via `MultiBlocProvider` at the root `DoctorAppointment` widget so they are accessible from any widget in the tree.

Route-scoped Cubits are provided by their respective GoRouter `builder` functions using `BlocProvider` or `MultiBlocProvider`, ensuring each screen gets a fresh Cubit instance.

### Caching Strategy

Two Hive-backed cache services complement the BLoC layer:
- **`ChatCacheService`**: Persists real-time chat messages and conversation metadata so they load instantly before the API response.
- **`AppCacheService`**: Persists patient profile and appointments list for offline viewing.

---

## 9. Testing

The `test/` directory exists but currently contains **no test files**. The project was developed under time pressure typical of a graduation project, and testing was deferred.

### What Should Be Tested (Recommended Future Work)

**Unit Tests (Use Cases & Repositories)**
- `LoginUseCase` — valid credentials, invalid credentials, network failure.
- `AuthTokenInterceptor` — 401 handling, token refresh, concurrent requests.
- `ChatCubit` — `initChat`, `sendMessage`, `get_doctors` tool-call flow.
- `AppointmentsCubit` — load, cancel, reschedule state transitions.

**Widget Tests**
- `BookingDateView` — slot selection, calendar interaction.
- `ChatbotView` — message send, radio/checkbox selector rendering.
- `LoginView` — form validation, error display.

**Integration Tests**
- Full booking flow from doctor selection to booking confirmation.
- Forgot password OTP flow.

---

## 10. Notable Technical Challenges

### Challenge 1: Concurrent 401 Token Refresh Race Condition

**Problem**: Multiple API calls failing simultaneously with 401 would each attempt to refresh the token, causing duplicate refresh requests and potentially invalidating the refresh token itself.

**Solution**: The `AuthTokenInterceptor` uses a **single-flight pattern** with a boolean lock (`_isRefreshing`) and a `Completer<void>? _refreshCompleter`. The first 401 starts the refresh and all concurrent 401 failures await the same `Completer`. After the refresh completes, all queued requests retry with the new token. If refresh fails, all requests are redirected to login.

---

### Challenge 2: Proactive Token Refresh on App Startup

**Problem**: The stored JWT could expire while the app is closed. Resuming the app with a stale token causes the first API call (e.g., the doctor list on home) to fail with a 401, creating a flash of broken content.

**Solution**: `SplashView._handleStartup()` proactively calls `RefreshTokenUseCase` before routing. The fresh token is persisted to both storage layers immediately, so every subsequent API call in the session uses a valid token. If offline, the splash falls back to the cached token and lets the interceptor handle any later 401.

---

### Challenge 3: Adaptive Layout for Web/Desktop

**Problem**: The app was originally designed for 375px mobile. Running on a 1440px desktop window made all elements absurdly large.

**Solution**: `ScreenUtilInit` detects desktop vs mobile via `LayoutBuilder`. On desktop, the `designSize` is set to the actual window size so the scale factor becomes 1.0 (disabling scaling). `ResponsiveFramework` adds breakpoints and `ResponsiveScaledBox` to scale small-screen UIs. Individual screens like `BookingDateView` use `LayoutBuilder` to switch between single-column (mobile) and two-column (desktop) layouts.

---

### Challenge 4: AI Chatbot Tool-Call Relay

**Problem**: The AI backend uses a function-calling pattern — when the AI detects the user needs doctors, it returns `type: "get_doctors"` with search parameters instead of a text response. The Flutter client needs to fetch doctors, format the result, and send it back to the AI as a "tool result" before the AI provides the final response to the user.

**Solution**: `ChatCubit._handleSendResponse()` checks `response.type`. If `"get_doctors"`, it orchestrates two additional async operations (resolve specialization ID → search doctors) then calls `_sendAIChatMessageUseCase` again with a `toolResult` payload. The recursion is limited by the AI's final `"chat"` type response. This entire multi-step flow is invisible to the user who only sees the final AI message.

---

### Challenge 5: Real-Time Chat with Offline Caching

**Problem**: SignalR connections drop on poor networks. Displaying stale chat while reconnecting leads to a confusing UX. Additionally, loading 50+ messages on every chat open is slow.

**Solution**: 
- **`ChatSignalRService`** uses `.withAutomaticReconnect()` and broadcasts a `connectionStream` so `UserChatCubit` can update a connection status indicator in the UI.
- **`ChatCacheService`** (Hive) persists conversation metadata and messages locally. The cubit loads from cache first, then fetches from the API, and patches the UI seamlessly when fresh data arrives.

---

### Challenge 6: Payment State Management Across Navigation

**Problem**: The payment flow spans multiple screens (Checkout → WebView → Status). The `PaymentCubit` instance must survive navigation pushes and must not be garbage-collected between the WebView result and the status polling screen.

**Solution**: The `PaymentCubit` is created in `CheckoutView` using `getIt<PaymentCubit>()` and stored as a field (`late final PaymentCubit _cubit`). It is passed explicitly to `PaymentWebViewScreen` and `PaymentStatusView` as a constructor argument (using `BlocProvider.value`), ensuring the same cubit instance and its state are shared across the entire payment journey without relying on the widget tree.

---

*This document was generated based on source code analysis of the MedLink Flutter project.*
