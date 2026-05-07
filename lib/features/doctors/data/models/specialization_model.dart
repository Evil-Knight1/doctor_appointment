import 'package:doctor_appointment/features/doctors/domain/entities/specialization.dart';

class SpecializationModel extends Specialization {
  const SpecializationModel({
    required super.id,
    required super.name,
    super.description,
    super.icon,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );
  }
}
