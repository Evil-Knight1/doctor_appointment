import 'package:doctor_appointment/core/errors/exceptions.dart';
import 'package:doctor_appointment/core/services/api_service.dart';
import 'package:doctor_appointment/features/doctors/data/models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<ReviewModel> addReview({
    required int doctorId,
    required int stars,
    required String comment,
  });
  Future<List<ReviewModel>> getDoctorReviews(int doctorId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiService apiService;

  ReviewRemoteDataSourceImpl(this.apiService);

  @override
  Future<ReviewModel> addReview({
    required int doctorId,
    required int stars,
    required String comment,
  }) async {
    final response = await apiService.post(
      '/api/Review',
      data: {'doctorId': doctorId, 'stars': stars, 'comment': comment},
    );

    final success = response['success'] == true;
    if (!success) {
      throw ApiException(_extractMessage(response));
    }

    return ReviewModel.fromJson(response['data']);
  }

  @override
  Future<List<ReviewModel>> getDoctorReviews(int doctorId) async {
    final response = await apiService.get('/api/Review/doctor/$doctorId');

    final success = response['success'] == true;
    if (!success) {
      throw ApiException(_extractMessage(response));
    }

    final List data = response['data'] ?? [];
    return data.map((json) => ReviewModel.fromJson(json)).toList();
  }

  String _extractMessage(Map<String, dynamic> response) {
    if (response['message'] != null) return response['message'] as String;
    final errors = response['errors'];
    if (errors is List && errors.isNotEmpty) return errors.first.toString();
    return 'Operation failed';
  }
}
