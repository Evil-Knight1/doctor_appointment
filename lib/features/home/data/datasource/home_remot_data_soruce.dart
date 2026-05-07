import 'package:doctor_appointment/core/errors/exceptions.dart';
import 'package:doctor_appointment/core/services/api_service.dart';
import 'package:doctor_appointment/features/doctors/data/models/specialization_model.dart';
import 'package:doctor_appointment/features/home/data/models/top_doctors_model.dart';

abstract class HomeRemotDataSource {
  Future<TopDoctorsModel> getTopDoctors({int? count});
  Future<TopDoctorsModel> getDoctorsBySpecialization(
    int specializationId, {
    int? count,
  });
  Future<List<SpecializationModel>> getSpecializations();
}

class HomeRemotDataSourceImpl implements HomeRemotDataSource {
  final ApiService apiService;

  HomeRemotDataSourceImpl(this.apiService);

  @override
  Future<TopDoctorsModel> getTopDoctors({int? count}) async {
    final response = await apiService.get(
      '/api/top-doctors',
      queryParameters: count != null ? {'count': count} : null,
    );

    final success = response['success'] == true;
    if (!success) {
      throw ApiException(_extractMessage(response));
    }

    return TopDoctorsModel.fromJson(response);
  }

  @override
  Future<TopDoctorsModel> getDoctorsBySpecialization(
    int specializationId, {
    int? count,
  }) async {
    final response = await apiService.get(
      '/api/Home/doctors-by-specialization/$specializationId',
      queryParameters: count != null ? {'count': count} : null,
    );

    final success = response['success'] == true;
    if (!success) {
      throw ApiException(_extractMessage(response));
    }

    return TopDoctorsModel.fromJson(response);
  }

  @override
  Future<List<SpecializationModel>> getSpecializations() async {
    final response = await apiService.get('/api/Doctor/specializations');

    final success = response['success'] == true;
    if (!success) {
      throw ApiException(_extractMessage(response));
    }

    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String _extractMessage(Map<String, dynamic> json) {
    final message = json['message'] as String?;
    if (message != null && message.trim().isNotEmpty) {
      return message;
    }
    final errors = json['errors'];
    if (errors is List && errors.isNotEmpty) {
      return errors.map((e) => e.toString()).join(', ');
    }
    return 'Request failed';
  }
}
