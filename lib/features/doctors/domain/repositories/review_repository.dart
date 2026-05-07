import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/doctors/domain/entities/review.dart';

abstract class ReviewRepository {
  Future<Result<Review>> addReview({
    required int doctorId,
    required int stars,
    required String comment,
  });
  Future<Result<List<Review>>> getDoctorReviews(int doctorId);
}
