---
name: payment-workflow
description: >
  End-to-end payment workflow for the Doctor Appointment app, covering
  all three payment methods (card, wallet, cash), the Paymob integration,
  backend polling strategy, and state machine.
---

# Payment Workflow

## Overview

Payments are handled via **Paymob** (MENA payment gateway). The Flutter app
never holds payment keys directly — the backend creates the session and the
app uses the `flutter_paymob` SDK.

Three payment methods are supported:

| Code | Method | Flow |
|------|--------|------|
| `4` | Online Card | Paymob SDK card WebView → backend webhook → polling |
| `5` | Mobile Wallet | Paymob SDK wallet WebView → backend webhook → polling |
| `3` | Cash at Clinic | Appointment created → immediate confirmation (no gateway) |

---

## End-to-End Flow

### Card / Wallet Flow

```
Patient selects doctor slot & reason
          │
          ▼
[PaymentCubit.checkout()]
          │
          ├─ Step 1: POST /api/Appointment
          │          Creates appointment → returns appointmentId
          │          Emits: PaymentLoading("Creating appointment…")
          │
          ├─ Step 2: FlutterPaymob.instance.payWithCard()
          │          or .payWithWallet()
          │          (SDK opens Paymob UI)
          │          Emits: PaymentLoading("Opening payment gateway…")
          │
          ├─ Step 3: Paymob UI → user completes/cancels payment
          │          SDK callback: onWebViewResult(success, transactionId)
          │
          ├─ Step 4: Best-effort POST /api/Payment/report-completion
          │          (fire-and-forget; backend webhook is authoritative)
          │
          └─ Step 5 (if success): startPolling()
                     │
                     ├─ Emits: PaymentPendingVerification
                     │
                     ├─ Every 5 seconds: GET /api/Payment/status/{appointmentId}
                     │
                     ├─ If status == "paid"   → Emits: PaymentSuccess
                     ├─ If status == terminal
                     │    and not paid         → Emits: PaymentFailure
                     └─ If 12 attempts exceeded → Emits: PaymentFailure
                                                   (advise user to check later)
```

### Cash Flow

```
Patient selects "Cash at Clinic"
          │
          ▼
[PaymentCubit.checkout(paymentMethod: 3)]
          │
          ├─ POST /api/Appointment (paymentMethod=3)
          │
          └─ Emits: PaymentCashConfirmed(appointmentId, amount)
             (no gateway, no polling needed)
```

---

## State Machine

```
PaymentInitial
    │
    └─ checkout() called
           │
           ▼
    PaymentLoading("Creating appointment…")
           │
           ├─ Failure → PaymentFailure
           │
           └─ Success (cash)   → PaymentCashConfirmed  ◄── terminal
           │
           └─ Success (card/wallet)
                  │
                  ▼
           PaymentLoading("Opening payment gateway…")
                  │
                  ├─ User cancels → PaymentCancelled   ◄── terminal
                  │
                  └─ User succeeds
                         │
                         ▼
                  PaymentPendingVerification
                  (polls every 5s, max 12x)
                         │
                         ├─ status == paid          → PaymentSuccess   ◄── terminal
                         ├─ status == terminal≠paid → PaymentFailure   ◄── terminal
                         └─ max polls exceeded      → PaymentFailure   ◄── terminal
```

---

## Key Files

| File | Role |
|------|------|
| `lib/features/payments/logic/payment_cubit.dart` | Orchestration, polling, state emission |
| `lib/features/payments/logic/payment_state.dart` | All state classes |
| `lib/features/payments/data/datasources/payment_remote_data_source.dart` | REST calls |
| `lib/features/payments/domain/usecases/create_payment_session_usecase.dart` | Create session use-case |
| `lib/features/payments/domain/usecases/get_payment_status_usecase.dart` | Status polling use-case |
| `lib/features/payments/data/services/paymob_sdk_service.dart` | Paymob SDK wrapper |

---

## API Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `POST` | `/api/Payment/create-session` | Create Paymob payment session |
| `GET` | `/api/Payment/status/{appointmentId}` | Poll backend for final status |
| `POST` | `/api/Payment/report-completion` | Best-effort client notification (non-authoritative) |
| `GET` | `/api/Payment/patient/my-payments` | Patient payment history |

---

## Polling Strategy

- **Max attempts:** 12
- **Interval:** every 5 seconds (60 seconds total max wait)
- **Source of truth:** Backend webhook from Paymob — NOT the WebView callback
- **On network error during poll:** keep retrying until max attempts
- **On max exceeded:** emit `PaymentFailure` with message advising user to
  check appointment status later

---

## Important Notes

> **Webhook is authoritative.** The `onWebViewResult` callback is a UX
> hint only. Always wait for webhook-confirmed status via polling.

> **Cash payments** bypass the gateway entirely. The appointment is
> created with `paymentMethod=3` and `PaymentCashConfirmed` is emitted
> immediately.

> **Paymob keys** are never stored in the Flutter app. The backend
> creates the session and returns a `paymentUrl` or handles SDK auth.
