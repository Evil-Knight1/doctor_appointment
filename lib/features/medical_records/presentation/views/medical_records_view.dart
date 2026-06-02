import 'dart:convert';
import 'package:doctor_appointment/core/services/shared_preferences_helper.dart';
import 'package:doctor_appointment/core/theme/app_theme_extension.dart';
import 'package:doctor_appointment/core/utils/go_router.dart';
import 'package:doctor_appointment/features/medical_records/logic/medical_records_cubit.dart';
import 'package:doctor_appointment/features/medical_records/logic/medical_records_state.dart';
import 'package:doctor_appointment/features/medical_records/data/models/medical_record_model.dart';
import 'package:doctor_appointment/features/medical_records/data/models/medical_record_document_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_appointment/l10n/app_localizations.dart';

class MedicalRecordsView extends StatefulWidget {
  final int? patientId;

  const MedicalRecordsView({super.key, this.patientId});

  @override
  State<MedicalRecordsView> createState() => _MedicalRecordsViewState();
}

class _MedicalRecordsViewState extends State<MedicalRecordsView> {
  late int _patientId;

  @override
  void initState() {
    super.initState();
    if (widget.patientId != null) {
      _patientId = widget.patientId!;
    } else {
      final userDataStr = SharedPreferencesHelper.getUserData();
      if (userDataStr != null) {
        final Map<String, dynamic> userData = jsonDecode(userDataStr);
        _patientId = userData['userId'] as int? ?? 0;
      } else {
        _patientId = 0;
      }
    }
    context.read<MedicalRecordsCubit>().fetchMedicalRecords(_patientId);
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
          AppLocalizations.of(context)!.medicalRecordsTitle,
          style: context.styleSemiBold18.copyWith(color: colorScheme.onSurface),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRouter.kCreateRecordView, extra: _patientId).then((_) {
             if (!context.mounted) return;
             context.read<MedicalRecordsCubit>().fetchMedicalRecords(_patientId);
          });
        },
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add_rounded, color: colorScheme.onPrimary),
      ),
      body: BlocBuilder<MedicalRecordsCubit, MedicalRecordsState>(
        builder: (context, state) {
          if (state is MedicalRecordsLoading || state is MedicalRecordsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MedicalRecordsError) {
            return Center(child: Text(state.message));
          } else if (state is MedicalRecordsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<MedicalRecordsCubit>().fetchMedicalRecords(_patientId);
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Medical Profile",
                                style: context.styleSemiBold18.copyWith(color: colorScheme.onSurface),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push(AppRouter.kEditMedicalRecordView, extra: {
                                    'patientId': _patientId,
                                    'record': state.record,
                                  }).then((_) {
                                     if (!context.mounted) return;
                                     context.read<MedicalRecordsCubit>().fetchMedicalRecords(_patientId);
                                  });
                                },
                                child: Text("Edit", style: context.styleSemiBold14.copyWith(color: colorScheme.primary)),
                              )
                            ],
                          ),
                          SizedBox(height: 12.h),
                          _buildProfileCard(context, state.record),
                          SizedBox(height: 24.h),
                          Text(
                            "Uploaded Documents",
                            style: context.styleSemiBold18.copyWith(color: colorScheme.onSurface),
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ),
                  if (state.documents.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                        child: Center(
                          child: Text("No documents uploaded.", style: context.styleMedium14.copyWith(color: colorScheme.onSurfaceVariant)),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          mainAxisExtent: 100.h,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildDocumentCard(context, state.documents[index]);
                          },
                          childCount: state.documents.length,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, MedicalRecordModel record) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileRow("Blood Type", record.bloodType ?? "N/A"),
          _buildProfileRow("Height", record.height != null ? "${record.height} cm" : "N/A"),
          _buildProfileRow("Weight", record.weight != null ? "${record.weight} kg" : "N/A"),
          _buildProfileRow("Allergies", record.allergies ?? "None"),
          _buildProfileRow("Chronic Diseases", record.chronicDiseases ?? "None"),
          _buildProfileRow("Medications", record.medications ?? "None"),
          if (record.additionalNotes != null && record.additionalNotes!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text("Notes: ${record.additionalNotes}", style: context.styleMedium14.copyWith(color: colorScheme.onSurfaceVariant)),
          ]
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.styleMedium14.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value, style: context.styleSemiBold14.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, MedicalRecordDocumentModel document) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.description_outlined,
              color: colorScheme.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  document.fileName,
                  style: context.styleSemiBold16.copyWith(color: colorScheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Uploaded: ${document.uploadedAt.toLocal().toString().split(' ')[0]}',
                  style: context.styleRegular12.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: colorScheme.error),
            onPressed: () {
               // Show confirmation dialog before deleting
               showDialog(
                 context: context,
                 builder: (dialogContext) => AlertDialog(
                   title: const Text('Delete Document'),
                   content: const Text('Are you sure you want to delete this document?'),
                   actions: [
                     TextButton(
                       onPressed: () => Navigator.pop(dialogContext),
                       child: const Text('Cancel'),
                     ),
                     TextButton(
                       onPressed: () {
                         Navigator.pop(dialogContext);
                         context.read<MedicalRecordsCubit>().deleteDocument(_patientId, document.id);
                       },
                       child: const Text('Delete', style: TextStyle(color: Colors.red)),
                     ),
                   ],
                 ),
               );
            },
          ),
        ],
      ),
    );
  }
}
