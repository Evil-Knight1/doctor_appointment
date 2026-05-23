---
name: chat-workflow
description: >
  Real-time 1-on-1 chat workflow between patients and doctors using
  SignalR WebSockets, REST history, unread counts, and mark-as-read.
---

# Chat Workflow

## Overview

The chat feature provides **real-time 1-on-1 messaging** between patients
and doctors via **ASP.NET Core SignalR** over WebSocket. REST endpoints
are used for history, conversations list, and read-state management.

---

## Architecture Layers

```
lib/features/chat/
├── data/
│   ├── datasources/
│   │   └── chat_remote_data_source.dart   # REST: history, conversations, mark-read
│   ├── models/
│   │   ├── chat_message_model.dart
│   │   └── conversation_model.dart
│   └── services/
│       └── chat_signalr_service.dart      # WebSocket: connect, send, receive
├── logic/
│   └── user_chat_cubit.dart               # Cubit orchestrating both sources
└── ui/
    ├── views/
    │   ├── conversations_view.dart         # List of all conversations
    │   └── chat_view.dart                  # Individual chat screen
    └── widgets/
```

---

## SignalR Connection Lifecycle

```
ChatSignalRServiceImpl.connect()
    │
    ├─ Already connected? → return true immediately
    │
    ├─ Get JWT from AuthLocalDataSource
    │       └─ No session? → emit error, return false
    │
    ├─ Build HubConnection
    │       ├─ URL: {apiUrl}/chathub
    │       ├─ accessTokenFactory: () => session.token
    │       └─ .withAutomaticReconnect()
    │
    ├─ Register event handlers:
    │       ├─ onclose      → connectionStream.add(false)
    │       ├─ onreconnecting → connectionStream.add(false)
    │       └─ onreconnected  → connectionStream.add(true)
    │
    ├─ Register hub listeners:
    │       ├─ 'ReceiveMessage' → messageStream.add(ChatMessageModel)
    │       ├─ 'MessageSent'    → messageStream.add(ChatMessageModel)
    │       ├─ 'MessagesRead'   → readStream.add(readerId)
    │       ├─ 'MessageRead'    → readStream.add(readerId)
    │       └─ 'Error'          → errorStream.add(errorText)
    │
    └─ _connection.start()
           ├─ Success → connectionStream.add(true), return true
           └─ Failure → errorStream.add(...), connectionStream.add(false), return false
```

---

## Streams Exposed by `ChatSignalRService`

| Stream | Type | Purpose |
|--------|------|---------|
| `messageStream` | `Stream<ChatMessageModel>` | New incoming / sent messages |
| `errorStream` | `Stream<String>` | Connection or send errors |
| `readStream` | `Stream<int>` | User ID of who read messages |
| `connectionStream` | `Stream<bool>` | Connection state changes |

---

## Sending a Message

```
User types + hits Send
    │
    ▼
UserChatCubit.sendMessage(receiverId, text)
    │
    ├─ Via SignalR (preferred when connected):
    │       ChatSignalRService.sendMessage(receiverId, message)
    │           → hub.invoke('SendMessage', args: [receiverId, message])
    │           → server broadcasts back via 'MessageSent' event
    │
    └─ Via REST (fallback / offline):
            POST /api/Chat/send  { receiverId, message }
            → returns ChatMessageModel
```

---

## Loading Chat History

```
ChatView opens for a conversation partner (otherUserId)
    │
    ▼
UserChatCubit.loadHistory(otherUserId)
    │
    ▼
GET /api/Chat/history/{otherUserId}?pageNumber=1&pageSize=50
    │
    ▼
Returns List<ChatMessageModel> (paginated, most recent first)
    │
    ▼
PUT /api/Chat/read/{otherUserId}   ← mark all as read immediately
```

---

## Conversations List

```
ConversationsView opens
    │
    ▼
GET /api/Chat/conversations
    │
    Returns List<ConversationModel>
    (each has: otherUserId, name, avatar, lastMessage, unreadCount)
    │
    ▼
GET /api/Chat/unread-count   ← total badge count for nav bar
```

---

## Unread Badge

- On app start / tab switch: `GET /api/Chat/unread-count`
- When a real-time message arrives via `messageStream`: increment local count
- When chat screen opens: `PUT /api/Chat/read/{otherUserId}` → reset count
- Notification tray "Seen" button: same `PUT /api/Chat/read/{otherUserId}`
  executed in background without opening the app

---

## Message Reporting

```
User long-presses a message → Report
    │
    ▼
POST /api/Chat/report  { reportedMessageId, reason }
    │
    Returns bool (success/failure)
```

---

## REST Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `GET` | `/api/Chat/history/{otherUserId}` | Paginated message history |
| `GET` | `/api/Chat/conversations` | All conversation threads |
| `PUT` | `/api/Chat/read/{otherUserId}` | Mark messages as read |
| `GET` | `/api/Chat/unread-count` | Total unread count |
| `POST` | `/api/Chat/send` | Send message (REST fallback) |
| `POST` | `/api/Chat/report` | Report a message |

## SignalR Hub Methods

| Direction | Method | Description |
|-----------|--------|-------------|
| Client → Server | `SendMessage(receiverId, message)` | Send a chat message |
| Server → Client | `ReceiveMessage(ChatMessageModel)` | Incoming message from other party |
| Server → Client | `MessageSent(ChatMessageModel)` | Confirmation of your sent message |
| Server → Client | `MessagesRead(readerId)` | Other party read your messages |
| Server → Client | `MessageRead(readerId)` | Alias for MessagesRead |
| Server → Client | `Error(message)` | Hub-level error |

---

## Important Notes

> **SignalR with automatic reconnect.** `withAutomaticReconnect()` means
> the SDK will attempt to reconnect after drops. UI should listen to
> `connectionStream` and show an "offline" indicator when `false`.

> **JWT in SignalR.** The `accessTokenFactory` callback is called each
> time SignalR needs the token, so refreshed tokens are picked up
> automatically on reconnect.

> **`readStream` payload.** The server may send the reader's id as a plain
> `int`, a map `{readerId: ...}`, or a stringified number. The service
> normalises all three forms before pushing to `readStream`.
