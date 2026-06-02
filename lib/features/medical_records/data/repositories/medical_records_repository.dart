import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor_appointment/core/errors/failures.dart';
import 'package:doctor_appointment/core/services/api_service.dart';
import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/medical_records/data/models/medical_record_model.dart';
import 'package:doctor_appointment/features/medical_records/data/models/medical_record_document_model.dart';

abstract class MedicalRecordsRepository {
  // GET /api/MedicalRecord/patient/{patientId}
  Future<Result<MedicalRecordModel>> getMedicalRecord(int patientId);
  // PUT /api/MedicalRecord/patient  (no patientId in URL)
  Future<Result<MedicalRecordModel>> updateMedicalRecord(MedicalRecordModel record);
  // GET /api/MedicalRecord/patient/{patientId}/documents
  Future<Result<List<MedicalRecordDocumentModel>>> getDocuments(int patientId);
  // POST /api/MedicalRecord/patient/documents (no patientId in URL)
  Future<Result<MedicalRecordDocumentModel>> uploadDocument(File file);
  // DEL /api/MedicalRecord/documents/{documentId}
  Future<Result<void>> deleteDocument(int documentId);
}

class MedicalRecordsRepositoryImpl implements MedicalRecordsRepository {
  final ApiService apiService;

  MedicalRecordsRepositoryImpl(this.apiService);

  @override
  Future<Result<MedicalRecordModel>> getMedicalRecord(int patientId) async {
    try {
      final response = await apiService.get('/api/MedicalRecord/patient/$patientId');
      final Map<String, dynamic> data =
          response is Map<String, dynamic> && response.containsKey('data')
          ? response['data']
          : response;
      return Success(MedicalRecordModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return Success(
            MedicalRecordModel(
              id: 0,
              patientId: patientId,
              lastUpdated: DateTime.now(),
              createdAt: DateTime.now(),
            ),
          );
        }
        return FailureResult(ServerFailure(e.message ?? 'Network Error'));
      }
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<MedicalRecordModel>> updateMedicalRecord(MedicalRecordModel record) async {
    try {
      final response = await apiService.put(
        '/api/MedicalRecord/patient',
        data: record.toJson(),
      );
      final Map<String, dynamic> data =
          response is Map<String, dynamic> && response.containsKey('data')
          ? response['data']
          : response;
      return Success(MedicalRecordModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return FailureResult(ServerFailure(e.message ?? 'Network Error'));
      }
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MedicalRecordDocumentModel>>> getDocuments(int patientId) async {
    try {
      final response = await apiService.get('/api/MedicalRecord/patient/$patientId/documents');

      List<dynamic> data = [];
      if (response is List) {
        data = response;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] is List) {
          data = response['data'] as List;
        } else if (response.containsKey('documents') && response['documents'] is List) {
          data = response['documents'] as List;
        } else if (response.containsKey('items') && response['items'] is List) {
          data = response['items'] as List;
        } else {
          try {
            data = response.values.firstWhere((v) => v is List) as List;
          } catch (_) {
            // fallback to empty if no list is found
          }
        }
      }

      final docs = data.map((json) => MedicalRecordDocumentModel.fromJson(json)).toList();
      return Success(docs);
    } catch (e) {
      if (e is DioException) {
        return FailureResult(ServerFailure(e.message ?? 'Network Error'));
      }
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<MedicalRecordDocumentModel>> uploadDocument(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });
      final response = await apiService.post(
        '/api/MedicalRecord/patient/documents',
        data: formData,
      );
      final Map<String, dynamic> data =
          response is Map<String, dynamic> && response.containsKey('data')
          ? response['data']
          : response;
      return Success(MedicalRecordDocumentModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return FailureResult(ServerFailure(e.message ?? 'Network Error'));
      }
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteDocument(int documentId) async {
    try {
      await apiService.delete('/api/MedicalRecord/documents/$documentId');
      return const Success(null);
    } catch (e) {
      if (e is DioException) {
        return FailureResult(ServerFailure(e.message ?? 'Network Error'));
      }
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
