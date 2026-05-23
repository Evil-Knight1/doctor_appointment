---
name: doctor-booking-cancel-reschedule-workflow
description: >
  Complete workflows for doctor slot selection, appointment booking,
  cancellation (patient-initiated and admin), and rescheduling
  (patient request → doctor approval → new slot selection).
---

# Doctor, Booking, Cancellation & Rescheduling Workflow

## Overview

The appointment lifecycle involves three actors: **Patient**, **Doctor**,
and **Admin**. Each has different permissions at different stages.

---

## 1. Doctor Discovery & Slot Selection

```
Patient searches / browses doctors
    │
    ▼
GET /api/Doctor  (filters: speciality, location, name)
    │
    Returns: List<Doctor>
    │
    ▼
Patient taps a doctor → DoctorDetailsView
    GET /api/Doctor/{doctorId}
    GET /api/Review/doctor/{doctorId}
    │
    ▼
Patient taps "Book Appointment"
    │
    ▼
Patient selects a date
    │
    ▼
GET /api/Appointment/slots/{doctorId}?date=YYYY-MM-DD
    │
    Returns: List<SlotModel> { id, startTime, endTime, isAvailable }
    │
    ▼
Patient selects an available slot → BookingSummaryView
    (shows: doctor, slot time, reason input, payment method selection)
```

---

## 2. Appointment Booking

```
Patient fills reason + selects payment method
    │
    ▼
BookingCubit / PaymentCubit.checkout()
    │
    ▼
POST /api/Appointment
    Body: {
      doctorId,
      slotId,
      reason,
      paymentMethod,   // 1=Card, 2=Wallet, 3=Cash
      amount,
      type             // 0=InClinic (default)
    }
    │
    ├─ Success → AppointmentModel returned
    │               ├─ Cash    → PaymentCashConfirmed (done)
    │               └─ Card/Wallet → proceed to PaymentCubit flow
    │
    └─ Failure → ServerFailure with message shown to user
```

**Appointment Types:**

| Code | Type |
|------|------|
| `0` | In-Clinic (default) |
| `1` | Online (future) |

---

## 3. Viewing Appointments

```
Patient opens "My Appointments" / Calendar
    │
    ▼
GET /api/Appointment/patient/my-appointments
    │
    Returns: List<AppointmentModel>
    (status: Pending, Confirmed, Completed, Cancelled, Rescheduled, etc.)
```

---

## 4. Cancellation Flows

### 4a. Direct Cancel (Patient / Admin)

Used when a patient or admin can cancel without requiring approval:

```
Patient taps "Cancel"
    │
    ▼
POST /api/Appointment/{appointmentId}/cancel
    │
    ├─ Success → appointment status becomes "Cancelled"
    └─ Failure → error shown
```

Admin cancel (admin-only endpoint):
```
POST /api/Appointment/{appointmentId}/admin-cancel
```

### 4b. Request Cancel (Patient Initiates, Requires Approval)

Used when the appointment is in a state that requires a formal request:

```
Patient taps "Request Cancellation" + provides reason
    │
    ▼
POST /api/Appointment/{appointmentId}/request-cancel
    Body: { reason: "..." }
    │
    ├─ Success → appointment status becomes "CancellationRequested"
    │               → backend notifies doctor/admin via FCM
    └─ Failure → error shown
```

---

## 5. Rescheduling Flow

Rescheduling is a **multi-step collaborative process**:

```
STEP 1 — Patient requests reschedule
    │
    ▼
POST /api/Appointment/{appointmentId}/request-reschedule
    Body: { reason: "..." }
    │
    → appointment status: "RescheduleRequested"
    → doctor gets FCM notification

────────────────────────────────────────────────

STEP 2 — Doctor approves the reschedule request
    │
    ▼
POST /api/Appointment/{appointmentId}/doctor-approve-reschedule
    │
    → appointment status: "RescheduleApproved"
    → patient gets FCM notification

────────────────────────────────────────────────

STEP 3 — Patient selects a new slot
    │
    ▼
GET /api/Appointment/slots/{doctorId}?date=YYYY-MM-DD
    (same slot selection flow as initial booking)
    │
    Patient selects new slot
    │
    ▼
POST /api/Appointment/{appointmentId}/select-reschedule-slot
    Body: { newSlotId: 42 }
    │
    → appointment status: "Rescheduled"
    → both parties notified
```

---

## Appointment Status Machine

```
Pending
  │
  ├─ Doctor/Admin confirms   → Confirmed
  │                                │
  │                                ├─ Appointment occurs → Completed
  │                                │
  │                                ├─ Patient requests cancel → CancellationRequested
  │                                │       └─ Approved → Cancelled
  │                                │
  │                                ├─ Patient requests reschedule → RescheduleRequested
  │                                │       └─ Doctor approves → RescheduleApproved
  │                                │               └─ Patient selects slot → Rescheduled
  │                                │
  │                                └─ Admin cancels → Cancelled
  │
  └─ Rejected → Cancelled
```

---

## Use Cases

| Use Case | File | Endpoint |
|----------|------|----------|
| `CreateAppointmentUseCase` | `create_appointment_usecase.dart` | `POST /api/Appointment` |
| `GetMyAppointmentsUseCase` | `get_my_appointments_usecase.dart` | `GET /api/Appointment/patient/my-appointments` |
| `GetDoctorSlotsUseCase` | `get_doctor_slots_usecase.dart` | `GET /api/Appointment/slots/{doctorId}` |
| `CancelAppointmentUseCase` | `cancel_appointment_usecase.dart` | `POST /api/Appointment/{id}/cancel` |
| `RequestCancelUseCase` | `request_cancel_usecase.dart` | `POST /api/Appointment/{id}/request-cancel` |
| `RequestRescheduleUseCase` | `request_reschedule_usecase.dart` | `POST /api/Appointment/{id}/request-reschedule` |
| `DoctorApproveRescheduleUseCase` | `doctor_approve_reschedule_usecase.dart` | `POST /api/Appointment/{id}/doctor-approve-reschedule` |
| `SelectRescheduleSlotUseCase` | `select_reschedule_slot_usecase.dart` | `POST /api/Appointment/{id}/select-reschedule-slot` |
| `AdminCancelUseCase` | `admin_cancel_usecase.dart` | `POST /api/Appointment/{id}/admin-cancel` |

---

## Doctor-Side (Doctor Flow)

Doctors have a dedicated root `/doctorRoot` with:

- **Dashboard** — appointment counts, upcoming schedule
- **Appointment list** — view all upcoming appointments
- **Reschedule approval** — see `RescheduleRequested` appointments and
  call `DoctorApproveRescheduleUseCase`

---

## Important Notes

> **Slots are date-specific.** Always pass the selected `date` query param
> when fetching slots. Slots without `isAvailable=true` should be greyed out.

> **Amount is rounded.** The backend may reject float amounts for currency.
> The datasource rounds to an integer: `amount?.round()`.

> **Type defaults to 0.** If `type` is not provided, the backend treats it
> as in-clinic (0).

> **Payment is part of booking.** `createAppointment` and payment happen in
> the same `PaymentCubit.checkout()` call — not separately.
