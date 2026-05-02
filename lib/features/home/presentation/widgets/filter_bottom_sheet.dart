import 'package:doctor_appointment/core/utils/app_colors.dart';
import 'package:doctor_appointment/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterBottomSheet extends StatefulWidget {
  final String categoryName;

  const FilterBottomSheet({super.key, this.categoryName = 'Dentist'});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Fee range
  RangeValues _feeRange = const RangeValues(0, 1000000);

  // Availability
  final Set<String> _selectedAvailability = {};

  // Gender
  String? _selectedGender;

  // Consultation Type
  final Set<String> _selectedConsultationType = {};

  // Experience Level
  final Set<String> _selectedExperience = {};

  // Doctor Rating
  int? _selectedRating;

  // Language
  String? _selectedLanguage;

  // Country
  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            _buildHandle(),
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDividerSection('Fee / Price', _buildFeeSection()),
                    _buildDividerSection(
                      'Availability',
                      _buildAvailabilitySection(),
                    ),
                    _buildDividerSection(
                      'Doctor Rating',
                      _buildRatingSection(),
                    ),
                    _buildDividerSection(
                      'Consultation Type',
                      _buildConsultationSection(),
                    ),
                    _buildDividerSection(
                      'Experience Level',
                      _buildExperienceSection(),
                    ),
                    _buildDividerSection('Gender', _buildGenderSection()),
                    _buildDividerSection(
                      'Language Spoken',
                      _buildLanguageSection(),
                    ),
                    _buildDividerSection('Country', _buildCountrySection()),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Center(
        child: Container(
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
      child: Text(
        'Filter - ${widget.categoryName}',
        style: AppStyles.styleSemiBold22.copyWith(fontSize: 18.sp),
      ),
    );
  }

  Widget _buildDividerSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppStyles.styleMedium14.copyWith(fontSize: 13.sp),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
          ],
        ),
        SizedBox(height: 10.h),
        content,
        Divider(color: AppColors.border, height: 1),
      ],
    );
  }

  Widget _buildFeeSection() {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.border,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.1),
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
          ),
          child: RangeSlider(
            values: _feeRange,
            min: 0,
            max: 1000000,
            onChanged: (values) => setState(() => _feeRange = values),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$ ${_feeRange.start.toInt()}',
              style: AppStyles.styleRegular12.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '\$ ${_feeRange.end.toInt()}',
              style: AppStyles.styleRegular12.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    final options = ['Morning', 'Afternoon', 'Night'];
    return Wrap(
      spacing: 10.w,
      runSpacing: 8.h,
      children: options
          .map((o) => _chipToggle(o, _selectedAvailability))
          .toList(),
    );
  }

  Widget _buildGenderSection() {
    return Wrap(
      spacing: 10.w,
      children: ['Male', 'Female'].map((g) {
        final selected = _selectedGender == g;
        return GestureDetector(
          onTap: () => setState(() => _selectedGender = selected ? null : g),
          child: _buildChip(g, selected, icon: g == 'Male' ? '👨‍⚕️' : '👩‍⚕️'),
        );
      }).toList(),
    );
  }

  Widget _buildConsultationSection() {
    final options = ['Online', 'Home visit', 'Hospital'];
    return Wrap(
      spacing: 10.w,
      runSpacing: 8.h,
      children: options
          .map(
            (o) => _chipToggleWithIcon(
              o,
              _selectedConsultationType,
              _consultIcon(o),
            ),
          )
          .toList(),
    );
  }

  String _consultIcon(String type) {
    switch (type) {
      case 'Online':
        return '💻';
      case 'Home visit':
        return '🏠';
      default:
        return '🏥';
    }
  }

  Widget _buildExperienceSection() {
    final options = ['0-5 years', '5-10 years', '10+ years'];
    return Wrap(
      spacing: 10.w,
      runSpacing: 8.h,
      children: options
          .map((o) => _chipToggle(o, _selectedExperience))
          .toList(),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: List.generate(5, (i) {
        final star = i + 1;
        final selected = _selectedRating == star;
        return GestureDetector(
          onTap: () => setState(() => _selectedRating = selected ? null : star),
          child: Container(
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: selected ? Colors.white : AppColors.star,
                  size: 13.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  '$star',
                  style: AppStyles.styleRegular12.copyWith(
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLanguageSection() {
    return _buildDropdownField('Select Language', _selectedLanguage, (v) {
      setState(() => _selectedLanguage = v);
    }, ['English', 'Arabic', 'French', 'Spanish']);
  }

  Widget _buildCountrySection() {
    return _buildDropdownField(
      'Select Country',
      _selectedCountry,
      (v) {
        setState(() => _selectedCountry = v);
      },
      ['United States', 'Egypt', 'United Kingdom', 'UAE'],
    );
  }

  Widget _buildDropdownField(
    String hint,
    String? value,
    ValueChanged<String?> onChanged,
    List<String> items,
  ) {
    return Container(
      height: 44.h,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: AppStyles.styleRegular14.copyWith(
              color: AppColors.textLight,
              fontSize: 13.sp,
            ),
          ),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
          ),
          onChanged: onChanged,
          items: items
              .map(
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(i, style: AppStyles.styleMedium14),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _chipToggle(String label, Set<String> selectedSet) {
    final selected = selectedSet.contains(label);
    return GestureDetector(
      onTap: () => setState(() {
        if (selected) {
          selectedSet.remove(label);
        } else {
          selectedSet.add(label);
        }
      }),
      child: _buildChip(label, selected),
    );
  }

  Widget _chipToggleWithIcon(
    String label,
    Set<String> selectedSet,
    String icon,
  ) {
    final selected = selectedSet.contains(label);
    return GestureDetector(
      onTap: () => setState(() {
        if (selected) {
          selectedSet.remove(label);
        } else {
          selectedSet.add(label);
        }
      }),
      child: _buildChip(label, selected, icon: icon),
    );
  }

  Widget _buildChip(String label, bool selected, {String? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Text(icon, style: TextStyle(fontSize: 13.sp)),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: AppStyles.styleRegular12.copyWith(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _feeRange = const RangeValues(0, 1000000);
                  _selectedAvailability.clear();
                  _selectedGender = null;
                  _selectedConsultationType.clear();
                  _selectedExperience.clear();
                  _selectedRating = null;
                  _selectedLanguage = null;
                  _selectedCountry = null;
                });
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Text(
                'Clear',
                style: AppStyles.styleMedium14.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                elevation: 0,
              ),
              child: Text('Filter', style: AppStyles.styleSemiBold16),
            ),
          ),
        ],
      ),
    );
  }
}
