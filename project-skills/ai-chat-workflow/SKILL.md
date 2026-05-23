---
name: ai-chat-workflow
description: >
  AI chatbot workflow for the Doctor Appointment app — session management,
  message exchange, history retrieval, and rate-limit handling.
---

# AI Chat Workflow

## Overview

The **AI Chatbot** feature gives patients access to an AI-powered assistant
backed by the backend API. Each conversation is a named **session** identified
by a UUID string. Sessions are persistent and can be resumed.

---

## Architecture Layers

```
lib/features/chatbot/
├── data/
│   ├── datasources/
│   │   └── ai_chat_remote_data_source.dart   # All API calls
│   ├── models/
│   │   └── ai_chat_models.dart               # Request/response DTOs
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── logic/
│   └── ai_chat_cubit.dart                    # State management
└── presentation/
    └── views/
        ├── ai_chat_list_view.dart            # Session list
        └── ai_chat_view.dart                 # Active chat screen
```

---

## Session Lifecycle

### Start New Chat

```
Patient taps "New Chat"
    │
    ▼
AIChatCubit → AIChatRemoteDataSource.startNewChat()
    │
    ▼
POST /api/AIChat/new-chat
    │
    Returns: sessionId (UUID string)
    │
    ▼
UI navigates to AIChatView(sessionId: sessionId)
```

### Resume Existing Chat

```
Patient opens session list
    │
    ▼
GET /api/AIChat/user-chats
    │
    Returns: List<String> (session IDs)
    │
    ▼
Patient selects a session
    │
    ▼
UI navigates to AIChatView(sessionId: selectedId)
    │
    ▼
AIChatCubit.loadHistory(sessionId)
    │
    ▼
GET /api/AIChat/history/{sessionId}
    │
    Returns: List<AIChatHistoryModel>
    (each has: role ["user"|"assistant"], content, timestamp)
```

---

## Sending a Message

```
Patient types message + sends
    │
    ▼
AIChatCubit.sendMessage(sessionId, userMessage)
    │
    ├─ Optimistically add user message to UI state
    │
    ▼
POST /api/AIChat/send
    Body: AIChatRequestModel { sessionId, message }
    │
    ├─ Success → Returns AIChatResponseModel { reply, sessionId }
    │               └─ Add AI reply to UI state
    │
    └─ HTTP 429 (Rate Limit Exceeded)
            └─ Extract backend message (e.g. "Rate limit: X requests/min")
               Emit error state with the rate-limit message
```

---

## Data Models

### `AIChatRequestModel`

```dart
{
  "sessionId": "uuid-string",
  "message": "What are symptoms of diabetes?"
}
```

### `AIChatResponseModel`

```dart
{
  "reply": "Diabetes symptoms include...",
  "sessionId": "uuid-string"
}
```

### `AIChatHistoryModel`

```dart
{
  "role": "user" | "assistant",
  "content": "message text",
  "timestamp": "2026-05-22T10:30:00Z"
}
```

---

## API Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `POST` | `/api/AIChat/new-chat` | Create a new session, returns `sessionId` |
| `GET` | `/api/AIChat/user-chats` | List all session IDs for the current user |
| `POST` | `/api/AIChat/send` | Send a message, returns AI reply |
| `GET` | `/api/AIChat/history/{sessionId}` | Load full history of a session |

---

## Error Handling

| Error | Handling |
|-------|---------|
| **HTTP 429 Rate Limit** | Caught from `DioException`; backend message shown to user |
| **Other DioException** | Generic "Failed to send message" error emitted |
| **Network timeout** | Standard `NetworkFailure` from repository layer |

---

## State Flow

```
AIChatInitial
    │
    ├─ loadHistory()
    │       ▼
    │  AIChatLoading
    │       │
    │       ├─ Success → AIChatLoaded(messages: List<AIChatHistoryModel>)
    │       └─ Failure → AIChatError(message)
    │
    └─ sendMessage()
            ▼
       AIChatSending (user message added to list optimistically)
            │
            ├─ Success → AIChatLoaded(messages + AI reply appended)
            └─ Failure → AIChatError(message)
                           (user message may be removed or shown with error badge)
```

---

## Important Notes

> **Session IDs are UUIDs.** They are opaque strings returned by the
> backend. The app never generates them.

> **Rate limiting.** The backend enforces a per-user request rate limit.
> HTTP 429 responses carry a human-readable message that should be
> displayed directly to the user.

> **No streaming.** The AI response arrives as a single HTTP response
> (not Server-Sent Events). If streaming is needed in the future, the
> datasource and cubit will need to be updated.

> **Authentication.** All `/api/AIChat/*` endpoints require a valid JWT
> Bearer token, attached automatically by `AuthTokenInterceptor`.
