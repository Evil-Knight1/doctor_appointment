import 'dart:io';
import 'package:doctor_appointment/core/theme/app_theme_extension.dart';
import 'package:doctor_appointment/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:doctor_appointment/features/on_boarding_view/presentation/widgets/custom_button.dart';
import 'package:doctor_appointment/features/medical_records/logic/medical_records_cubit.dart';
import 'package:doctor_appointment/features/medical_records/data/models/medical_record_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CreateRecordView extends StatefulWidget {
  final int patientId;

  const CreateRecordView({super.key, required this.patientId});

  @override
  State<CreateRecordView> createState() => _CreateRecordViewState();
}

class _CreateRecordViewState extends State<CreateRecordView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // File Picker variables
  File? _selectedFile;

  // Manual Entry controllers
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
    _tabController = TabController(length: 2, vsync: this);

    _bloodTypeController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _allergiesController = TextEditingController();
    _chronicController = TextEditingController();
    _medicationsController = TextEditingController();
    _surgeriesController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _uploadDocument() {
    if (_selectedFile != null) {
      context.read<MedicalRecordsCubit>().uploadDocument(widget.patientId, _selectedFile!);
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a file first.")),
      );
    }
  }

  void _saveManualRecord() {
    final newRecord = MedicalRecordModel(
      id: 0,
      patientId: widget.patientId,
      bloodType: _bloodTypeController.text.trim().isNotEmpty ? _bloodTypeController.text.trim() : null,
      height: double.tryParse(_heightController.text.trim()),
      weight: double.tryParse(_weightController.text.trim()),
      allergies: _allergiesController.text.trim().isNotEmpty ? _allergiesController.text.trim() : null,
      chronicDiseases: _chronicController.text.trim().isNotEmpty ? _chronicController.text.trim() : null,
      medications: _medicationsController.text.trim().isNotEmpty ? _medicationsController.text.trim() : null,
      surgeries: _surgeriesController.text.trim().isNotEmpty ? _surgeriesController.text.trim() : null,
      additionalNotes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      lastUpdated: DateTime.now(),
      createdAt: DateTime.now(),
    );
    context.read<MedicalRecordsCubit>().updateMedicalRecord(widget.patientId, newRecord);
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
          "Add Medical Record",
          style: context.styleSemiBold18.copyWith(color: colorScheme.onSurface),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(text: "Upload Document"),
            Tab(text: "Manual Entry"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUploadDocumentTab(context),
          _buildManualEntryTab(context),
        ],
      ),
    );
  }

  Widget _buildUploadDocumentTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upload Document",
            style: context.styleMedium14.copyWith(color: colorScheme.onSurface),
          ),
          SizedBox(height: 8.h),
          _buildUploadBox(context),
          SizedBox(height: 32.h),
          CustomButton(
            text: "Upload",
            onPressed: _uploadDocument,
            width: double.infinity,
            height: 50.h,
            circleSize: 12.r,
            textStyle: context.styleSemiBold16.copyWith(color: colorScheme.onPrimary),
            buttonColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colorScheme.outlineVariant,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _selectedFile != null ? Icons.check_circle_outline : Icons.cloud_upload_rounded,
              color: colorScheme.primary,
              size: 40.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              _selectedFile != null
                  ? _selectedFile!.path.split('/').last
                  : "Tap to select a document (PDF, Image)",
              style: context.styleMedium14.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualEntryTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField("Blood Type", _bloodTypeController, "e.g., O+, A-"),
          _buildField("Height (cm)", _heightController, "e.g., 175", TextInputType.number),
          _buildField("Weight (kg)", _weightController, "e.g., 70.5", TextInputType.number),
          _buildField("Allergies", _allergiesController, "e.g., Peanuts, Penicillin"),
          _buildField("Chronic Diseases", _chronicController, "e.g., Diabetes, Asthma"),
          _buildField("Medications", _medicationsController, "e.g., Metformin"),
          _buildField("Surgeries", _surgeriesController, "e.g., Appendectomy"),
          _buildField("Additional Notes", _notesController, "Any extra information"),
          SizedBox(height: 32.h),
          CustomButton(
            text: "Save Record",
            onPressed: _saveManualRecord,
            width: double.infinity,
            height: 50.h,
            circleSize: 12.r,
            textStyle: context.styleSemiBold16.copyWith(color: colorScheme.onPrimary),
            buttonColor: colorScheme.primary,
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String hint, [TextInputType type = TextInputType.text]) {
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
