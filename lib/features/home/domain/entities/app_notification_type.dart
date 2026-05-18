enum AppNotificationType {
  appointmentBooked(0),
  appointmentApproved(1),
  appointmentCancelled(2),
  appointmentReminder(3),
  chatMessage(4),
  reviewReceived(5),
  doctorApproved(6),
  general(7),
  newDoctorRegistration(8),
  paymentFailed(9),
  unknown(-1);

  const AppNotificationType(this.value);

  final int value;

  static AppNotificationType fromValue(int? value) {
    for (final type in AppNotificationType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return AppNotificationType.unknown;
  }
}

extension AppNotificationTypeX on AppNotificationType {
  bool get isAppointmentFlow =>
      this == AppNotificationType.appointmentBooked ||
      this == AppNotificationType.appointmentApproved ||
      this == AppNotificationType.appointmentCancelled ||
      this == AppNotificationType.appointmentReminder ||
      this == AppNotificationType.paymentFailed;

  bool get isChat => this == AppNotificationType.chatMessage;

  String get label {
    switch (this) {
      case AppNotificationType.appointmentBooked:
        return 'Booked';
      case AppNotificationType.appointmentApproved:
        return 'Approved';
      case AppNotificationType.appointmentCancelled:
        return 'Cancelled';
      case AppNotificationType.appointmentReminder:
        return 'Reminder';
      case AppNotificationType.chatMessage:
        return 'Message';
      case AppNotificationType.reviewReceived:
        return 'Review';
      case AppNotificationType.doctorApproved:
        return 'Doctor';
      case AppNotificationType.general:
        return 'General';
      case AppNotificationType.newDoctorRegistration:
        return 'Registration';
      case AppNotificationType.paymentFailed:
        return 'Payment';
      case AppNotificationType.unknown:
        return 'Update';
    }
  }
}
