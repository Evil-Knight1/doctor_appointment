class DoctorMonthlyRevenue {
  final int year;
  final int month;
  final String monthName;
  final double revenue;
  final int appointmentCount;

  const DoctorMonthlyRevenue({
    required this.year,
    required this.month,
    required this.monthName,
    required this.revenue,
    required this.appointmentCount,
  });
}
