class MedicalRecordDocumentModel {
  final int id;
  final int patientId;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final DateTime uploadedAt;

  MedicalRecordDocumentModel({
    required this.id,
    required this.patientId,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.uploadedAt,
  });

  factory MedicalRecordDocumentModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordDocumentModel(
      id: json['id'] as int? ?? 0,
      patientId: json['patientId'] as int? ?? 0,
      fileName: json['fileName'] as String? ?? 'Unknown File',
      fileUrl: json['fileUrl'] as String? ?? '',
      fileType: json['fileType'] as String? ?? '',
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.parse(json['uploadedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}
