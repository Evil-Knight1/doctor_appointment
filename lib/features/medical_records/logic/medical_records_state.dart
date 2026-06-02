import 'package:doctor_appointment/features/medical_records/data/models/medical_record_model.dart';
import 'package:doctor_appointment/features/medical_records/data/models/medical_record_document_model.dart';

abstract class MedicalRecordsState {
  const MedicalRecordsState();
}

class MedicalRecordsInitial extends MedicalRecordsState {
  const MedicalRecordsInitial();
}

class MedicalRecordsLoading extends MedicalRecordsState {
  const MedicalRecordsLoading();
}

class MedicalRecordsLoaded extends MedicalRecordsState {
  final MedicalRecordModel record;
  final List<MedicalRecordDocumentModel> documents;

  const MedicalRecordsLoaded(this.record, this.documents);
}

class MedicalRecordsError extends MedicalRecordsState {
  final String message;
  const MedicalRecordsError(this.message);
}

class MedicalRecordUpdating extends MedicalRecordsState {
  const MedicalRecordUpdating();
}

class MedicalRecordUpdateSuccess extends MedicalRecordsState {
  const MedicalRecordUpdateSuccess();
}

class MedicalRecordUpdateError extends MedicalRecordsState {
  final String message;
  const MedicalRecordUpdateError(this.message);
}

class MedicalRecordDocumentUploading extends MedicalRecordsState {
  const MedicalRecordDocumentUploading();
}

class MedicalRecordDocumentUploadSuccess extends MedicalRecordsState {
  const MedicalRecordDocumentUploadSuccess();
}

class MedicalRecordDocumentUploadError extends MedicalRecordsState {
  final String message;
  const MedicalRecordDocumentUploadError(this.message);
}

class MedicalRecordDocumentDeleting extends MedicalRecordsState {
  const MedicalRecordDocumentDeleting();
}
