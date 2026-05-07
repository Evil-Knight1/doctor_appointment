class Review {
  final int id;
  final int patientId;
  final String patientName;
  final int doctorId;
  final int stars;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Review({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.stars,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });
}
