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
    if (isClosed) return;
    emit(const MedicalRecordsLoading());

    // GET /api/MedicalRecord/patient/{patientId}
    final profileResult = await _repository.getMedicalRecord(patientId);
    // GET /api/MedicalRecord/patient/{patientId}/documents
    final documentsResult = await _repository.getDocuments(patientId);

    if (isClosed) return;

    if (profileResult is Success && documentsResult is Success) {
      emit(
        MedicalRecordsLoaded(
          (profileResult as Success<MedicalRecordModel>).data,
          (documentsResult as Success<List<MedicalRecordDocumentModel>>).data,
        ),
      );
    } else {
      String errorMessage = 'Failed to load medical records.';
      if (profileResult is FailureResult<MedicalRecordModel>) {
        errorMessage = profileResult.failure.message;
      } else if (documentsResult is FailureResult<List<MedicalRecordDocumentModel>>) {
        errorMessage = documentsResult.failure.message;
      }
      emit(MedicalRecordsError(errorMessage));
    }
  }

  Future<void> updateMedicalRecord(int patientId, MedicalRecordModel record) async {
    if (isClosed) return;
    emit(const MedicalRecordUpdating());

    // PUT /api/MedicalRecord/patient  (no patientId in URL)
    final result = await _repository.updateMedicalRecord(record);

    if (isClosed) return;

    if (result is Success) {
      emit(const MedicalRecordUpdateSuccess());
      await fetchMedicalRecords(patientId);
    } else if (result is FailureResult<MedicalRecordModel>) {
      emit(MedicalRecordUpdateError(result.failure.message));
    }
  }

  Future<void> uploadDocument(int patientId, File file) async {
    if (isClosed) return;
    emit(const MedicalRecordDocumentUploading());

    // POST /api/MedicalRecord/patient/documents  (no patientId in URL)
    final result = await _repository.uploadDocument(file);

    if (isClosed) return;

    if (result is Success) {
      emit(const MedicalRecordDocumentUploadSuccess());
      await fetchMedicalRecords(patientId);
    } else if (result is FailureResult<MedicalRecordDocumentModel>) {
      emit(MedicalRecordDocumentUploadError(result.failure.message));
    }
  }

  Future<void> deleteDocument(int patientId, int documentId) async {
    if (isClosed) return;
    emit(const MedicalRecordDocumentDeleting());

    // DEL /api/MedicalRecord/documents/{documentId}
    final result = await _repository.deleteDocument(documentId);

    if (isClosed) return;

    if (result is Success) {
      await fetchMedicalRecords(patientId);
    } else if (result is FailureResult<void>) {
      emit(MedicalRecordsError(result.failure.message));
    }
  }
}
