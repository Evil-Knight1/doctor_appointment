import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_appointment/core/utils/app_dimensions.dart';
import 'package:doctor_appointment/features/doctors/domain/entities/doctor.dart';
import 'package:doctor_appointment/core/utils/routes.dart';
import 'package:doctor_appointment/features/appointment/logic/doctor_slots_cubit.dart';
import 'package:doctor_appointment/features/appointment/logic/doctor_slots_state.dart';
import 'package:doctor_appointment/features/appointment/data/models/slot_model.dart';

import '../widgets/booking_stepper.dart';
import '../widgets/shared_app_bar.dart';
import 'package:doctor_appointment/core/theme/app_theme_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookingDateView extends StatefulWidget {
  const BookingDateView({super.key, required this.doctor});
  final Doctor doctor;

  @override
  State<BookingDateView> createState() => _BookingDateViewState();
}

class _BookingDateViewState extends State<BookingDateView> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  SlotModel? _selectedSlot;

  Map<String, List<SlotModel>> _groupSlots(List<SlotModel> slots) {
    final filteredSlots = slots.where((slot) => isSameDay(slot.startTime, _selectedDate)).toList();

    final Map<String, List<SlotModel>> categorized = {
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
    };

    for (var slot in filteredSlots) {
      final hour = slot.startTime.hour;
      if (hour < 12) {
        categorized['Morning']!.add(slot);
      } else if (hour < 17) {
        categorized['Afternoon']!.add(slot);
      } else {
        categorized['Evening']!.add(slot);
      }
    }

    return categorized;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const SharedAppBar(title: 'Book Appointment'),
      body: Column(
        children: [
          const BookingStepper(currentStep: 0),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.lg),
              children: [
                Text('Select Date', style: context.headingMedium),
                SizedBox(height: AppSpacing.md),
                _CalendarPicker(
                  selectedDate: _selectedDate,
                  onDateSelected: (d) {
                    setState(() {
                      _selectedDate = d;
                      _selectedSlot = null; // Reset selection on date change
                    });
                  },
                ),
                SizedBox(height: AppSpacing.xl),
                Text('Select Time', style: context.headingMedium),
                SizedBox(height: AppSpacing.md),
                BlocBuilder<DoctorSlotsCubit, DoctorSlotsState>(
                  builder: (context, state) {
                    if (state is DoctorSlotsLoading) {
                      return _buildLoadingSlots();
                    } else if (state is DoctorSlotsError) {
                      return _buildErrorState(state.message);
                    } else if (state is DoctorSlotsLoaded) {
                      final categorized = _groupSlots(state.slots);
                      final hasAnySlots = categorized.values.any((list) => list.isNotEmpty);

                      if (!hasAnySlots) {
                        return _buildNoSlotsAvailable();
                      }

                      return Column(
                        children: categorized.entries.map((entry) {
                          final category = entry.key;
                          final slots = entry.value;
                          if (slots.isEmpty) return const SizedBox.shrink();

                          return Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category,
                                  style: context.labelLarge.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                Wrap(
                                  spacing: AppSpacing.md,
                                  runSpacing: AppSpacing.md,
                                  children: slots.map((slot) {
                                    final isSelected = _selectedSlot?.id == slot.id;
                                    final timeStr = DateFormat('hh:mm a').format(slot.startTime);
                                    return GestureDetector(
                                      onTap: () => setState(() => _selectedSlot = slot),
                                      child: Container(
                                        width: (1.sw - AppSpacing.lg * 2 - AppSpacing.md * 2) / 3,
                                        padding: EdgeInsets.symmetric(vertical: 12.h),
                                        decoration: BoxDecoration(
                                          color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerLow,
                                          borderRadius: BorderRadius.circular(AppRadius.lg),
                                          border: Border.all(
                                            color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            timeStr,
                                            style: context.bodySmall.copyWith(
                                              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          _BottomAction(
            onNext: _selectedSlot == null
                ? null
                : () => context.pushNamed(
                      Routes.bookingPaymentView,
                      extra: {
                        'doctor': widget.doctor,
                        'date': _selectedDate,
                        'time': DateFormat('hh:mm a').format(_selectedSlot!.startTime),
                        'slotId': _selectedSlot!.id,
                        'amount': widget.doctor.consultationFee,
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSlots() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 80.w, height: 20.h, color: Colors.white),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: List.generate(
              6,
              (index) => Container(
                width: (1.sw - AppSpacing.lg * 2 - AppSpacing.md * 2) / 3,
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSlotsAvailable() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_today_outlined, size: 48.sp, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          SizedBox(height: AppSpacing.md),
          Text(
            'No slots available',
            style: context.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4.h),
          Text(
            'Please select another date',
            style: context.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error, size: 40.sp),
          SizedBox(height: AppSpacing.sm),
          Text(message, style: context.bodyMedium),
          TextButton(
            onPressed: () => context.read<DoctorSlotsCubit>().fetchSlots(widget.doctor.id),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _CalendarPicker extends StatelessWidget {
  const _CalendarPicker({
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 90)),
        focusedDay: selectedDate,
        currentDay: DateTime.now(),
        selectedDayPredicate: (day) => isSameDay(selectedDate, day),
        onDaySelected: (selectedDay, focusedDay) {
          onDateSelected(selectedDay);
        },
        calendarFormat: CalendarFormat.month,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: context.headingSmall,
          leftChevronIcon: Icon(Icons.chevron_left, color: colorScheme.primary),
          rightChevronIcon: Icon(Icons.chevron_right, color: colorScheme.primary),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: colorScheme.onPrimaryContainer),
          selectedDecoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(color: colorScheme.onPrimary),
          outsideDaysVisible: false,
          defaultTextStyle: context.bodyMedium.copyWith(color: colorScheme.onSurface),
          weekendTextStyle: context.bodyMedium.copyWith(color: colorScheme.error),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: context.labelMedium,
          weekendStyle: context.labelMedium.copyWith(color: colorScheme.error),
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({required this.onNext});
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            disabledBackgroundColor: colorScheme.outlineVariant,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
            elevation: 0,
          ),
          child: Text(
            'Next',
            style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.w600, fontSize: 15.sp),
          ),
        ),
      ),
    );
  }
}
