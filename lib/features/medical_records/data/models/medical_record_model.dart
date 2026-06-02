class MedicalRecordModel {
  final int id;
  final int patientId;
  final String? bloodType;
  final String? allergies;
  final String? chronicDiseases;
  final String? surgeries;
  final String? medications;
  final double? height;
  final double? weight;
  final String? additionalNotes;
  final DateTime lastUpdated;
  final DateTime createdAt;

  MedicalRecordModel({
    required this.id,
    required this.patientId,
    this.bloodType,
    this.allergies,
    this.chronicDiseases,
    this.surgeries,
    this.medications,
    this.height,
    this.weight,
    this.additionalNotes,
    required this.lastUpdated,
    required this.createdAt,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] as int? ?? 0,
      patientId: json['patientId'] as int? ?? 0,
      bloodType: json['bloodType'] as String?,
      allergies: json['allergies'] as String?,
      chronicDiseases: json['chronicDiseases'] as String?,
      surgeries: json['surgeries'] as String?,
      medications: json['medications'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      additionalNotes: json['additionalNotes'] as String?,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      if (bloodType != null) 'bloodType': bloodType,
      if (allergies != null) 'allergies': allergies,
      if (chronicDiseases != null) 'chronicDiseases': chronicDiseases,
      if (surgeries != null) 'surgeries': surgeries,
      if (medications != null) 'medications': medications,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (additionalNotes != null) 'additionalNotes': additionalNotes,
    };
  }

  MedicalRecordModel copyWith({
    int? id,
    int? patientId,
    String? bloodType,
    String? allergies,
    String? chronicDiseases,
    String? surgeries,
    String? medications,
    double? height,
    double? weight,
    String? additionalNotes,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) {
    return MedicalRecordModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      surgeries: surgeries ?? this.surgeries,
      medications: medications ?? this.medications,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
