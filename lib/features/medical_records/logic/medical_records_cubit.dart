import 'dart:io';
import 'package:doctor_appointment/features/medical_records/data/models/medical_record_document_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_appointment/core/utils/result.dart';
import 'package:doctor_appointment/features/medical_records/data/models/medical_record_model.dart';
import 'package:doctor_appointment/features/medical_records/data/repositories/medical_records_repository.dart';
import 'package:doctor_appointment/features/medical_records/logic/medical_records_state.dart';

class MedicalRecordsCubit extends Cubit<MedicalRecordsState> {
  final MedicalRecordsRepository _repository;

  MedicalRecordsCubit(this._repository) : super(const MedicalRecordsInitial());

  Future<void> fetchMedicalRecords(int patientId) async {
    emit(const MedicalRecordsLoading());

    final profileResult = await _repository.getMedicalRecord(patientId);
    final documentsResult = await _repository.getDocuments(patientId);

    if (profileResult is Success && documentsResult is Success) {
      emit(
        MedicalRecordsLoaded(
          (profileResult as Success).data,
          (documentsResult as Success).data,
        ),
      );
    } else {
      String errorMessage = 'Failed to load medical records.';
      if (profileResult is FailureResult<MedicalRecordModel>) {
        errorMessage = profileResult.failure.message;
      } else if (documentsResult
          is FailureResult<List<MedicalRecordDocumentModel>>) {
        errorMessage = documentsResult.failure.message;
      }
      emit(MedicalRecordsError(errorMessage));
    }
  }

  Future<void> updateMedicalRecord(
    int patientId,
    MedicalRecordModel record,
  ) async {
    emit(const MedicalRecordUpdating());

    final result = await _repository.updateMedicalRecord(patientId, record);

    if (result is Success) {
      emit(const MedicalRecordUpdateSuccess());
      await fetchMedicalRecords(patientId); // Refresh after success
    } else if (result is FailureResult<MedicalRecordModel>) {
      emit(MedicalRecordUpdateError(result.failure.message));
    }
  }

  Future<void> uploadDocument(int patientId, File file) async {
    emit(const MedicalRecordDocumentUploading());

    final result = await _repository.uploadDocument(patientId, file);

    if (result is Success) {
      emit(const MedicalRecordDocumentUploadSuccess());
      await fetchMedicalRecords(patientId); // Refresh after success
    } else if (result is FailureResult<MedicalRecordDocumentModel>) {
      emit(MedicalRecordDocumentUploadError(result.failure.message));
    }
  }

  Future<void> deleteDocument(int patientId, int documentId) async {
    emit(const MedicalRecordDocumentDeleting());

    final result = await _repository.deleteDocument(documentId);

    if (result is Success) {
      await fetchMedicalRecords(patientId); // Refresh after success
    } else if (result is FailureResult<void>) {
      emit(
        MedicalRecordsError(result.failure.message),
      ); // General error, or could make a specific one
    }
  }
}
