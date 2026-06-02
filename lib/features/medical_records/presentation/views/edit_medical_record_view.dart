import 'package:doctor_appointment/core/theme/app_theme_extension.dart';
import 'package:doctor_appointment/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:doctor_appointment/features/on_boarding_view/presentation/widgets/custom_button.dart';
import 'package:doctor_appointment/features/medical_records/data/models/medical_record_model.dart';
import 'package:doctor_appointment/features/medical_records/logic/medical_records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EditMedicalRecordView extends StatefulWidget {
  final int patientId;
  final MedicalRecordModel record;

  const EditMedicalRecordView({
    super.key,
    required this.patientId,
    required this.record,
  });

  @override
  State<EditMedicalRecordView> createState() => _EditMedicalRecordViewState();
}

class _EditMedicalRecordViewState extends State<EditMedicalRecordView> {
  late TextEditingController _bloodTypeController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _allergiesController;
  late TextEditingController _chronicController;
  late TextEditingController _medicationsController;
  late TextEditingController _surgeriesController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _bloodTypeController = TextEditingController(text: widget.record.bloodType);
    _heightController = TextEditingController(
      text: widget.record.height?.toString(),
    );
    _weightController = TextEditingController(
      text: widget.record.weight?.toString(),
    );
    _allergiesController = TextEditingController(text: widget.record.allergies);
    _chronicController = TextEditingController(
      text: widget.record.chronicDiseases,
    );
    _medicationsController = TextEditingController(
      text: widget.record.medications,
    );
    _surgeriesController = TextEditingController(text: widget.record.surgeries);
    _notesController = TextEditingController(
      text: widget.record.additionalNotes,
    );
  }

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _chronicController.dispose();
    _medicationsController.dispose();
    _surgeriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveRecord() {
    final updatedRecord = widget.record.copyWith(
      bloodType: _bloodTypeController.text.trim().isNotEmpty
          ? _bloodTypeController.text.trim()
          : "",
      height: double.tryParse(_heightController.text.trim()) ?? 60,
      weight: double.tryParse(_weightController.text.trim()) ?? 160,
      allergies: _allergiesController.text.trim().isNotEmpty
          ? _allergiesController.text.trim()
          : "",
      chronicDiseases: _chronicController.text.trim().isNotEmpty
          ? _chronicController.text.trim()
          : "",
      medications: _medicationsController.text.trim().isNotEmpty
          ? _medicationsController.text.trim()
          : "",
      surgeries: _surgeriesController.text.trim().isNotEmpty
          ? _surgeriesController.text.trim()
          : "",
      additionalNotes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : "",
    );
    context.read<MedicalRecordsCubit>().updateMedicalRecord(
      widget.patientId,
      updatedRecord,
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Edit Medical Profile",
          style: context.styleSemiBold18.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField("Blood Type", _bloodTypeController, "e.g., O+, A-"),
            _buildField(
              "Height (cm)",
              _heightController,
              "e.g., 175",
              TextInputType.number,
            ),
            _buildField(
              "Weight (kg)",
              _weightController,
              "e.g., 70.5",
              TextInputType.number,
            ),
            _buildField(
              "Allergies",
              _allergiesController,
              "e.g., Peanuts, Penicillin",
            ),
            _buildField(
              "Chronic Diseases",
              _chronicController,
              "e.g., Diabetes, Asthma",
            ),
            _buildField(
              "Medications",
              _medicationsController,
              "e.g., Metformin",
            ),
            _buildField(
              "Surgeries",
              _surgeriesController,
              "e.g., Appendectomy",
            ),
            _buildField(
              "Additional Notes",
              _notesController,
              "Any extra information",
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: "Save Changes",
              onPressed: _saveRecord,
              width: double.infinity,
              height: 50.h,
              circleSize: 12.r,
              textStyle: context.styleSemiBold16.copyWith(
                color: colorScheme.onPrimary,
              ),
              buttonColor: colorScheme.primary,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    String hint, [
    TextInputType type = TextInputType.text,
  ]) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.styleMedium14.copyWith(color: colorScheme.onSurface),
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: controller,
          hintText: hint,
          textInputType: type,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
