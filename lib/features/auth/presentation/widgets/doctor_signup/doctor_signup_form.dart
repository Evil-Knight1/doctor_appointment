import 'package:doctor_appointment/core/utils/registration_validators.dart';
import 'package:doctor_appointment/features/auth/presentation/widgets/doctor_signup/doctor_specialization_field.dart';
import 'package:doctor_appointment/features/auth/presentation/widgets/registration_date_picker.dart';
import 'package:doctor_appointment/features/auth/presentation/widgets/registration_dropdown.dart';
import 'package:doctor_appointment/features/auth/presentation/widgets/registration_phone_field.dart';
import 'package:doctor_appointment/features/auth/presentation/widgets/registration_text_field.dart';
import 'package:doctor_appointment/features/doctors/domain/entities/specialization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:doctor_appointment/core/widgets/image_picker_widget.dart';

class DoctorSignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final int step;
  final VoidCallback onShowClinicLocationPicker;
  final VoidCallback onShowHospitalLocationPicker;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final PhoneController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController yearsController;
  final TextEditingController licenseController;
  final TextEditingController bioController;
  final TextEditingController clinicAddressController;
  final TextEditingController hospitalController;
  final TextEditingController consultationFeeController;
  final Specialization? selectedSpecialization;
  final ValueChanged<Specialization?> onSpecializationChanged;
  final DateTime? selectedDateOfBirth;
  final ValueChanged<DateTime?> onDateOfBirthChanged;
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;

  /// Per-field server validation errors keyed by lowercase field name
  final Map<String, String> fieldErrors;

  const DoctorSignUpForm({
    super.key,
    required this.formKey,
    required this.step,
    required this.onShowClinicLocationPicker,
    required this.onShowHospitalLocationPicker,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.yearsController,
    required this.licenseController,
    required this.bioController,
    required this.clinicAddressController,
    required this.hospitalController,
    required this.consultationFeeController,
    required this.selectedSpecialization,
    required this.onSpecializationChanged,
    required this.profilePicturePath,
    required this.onProfilePictureChanged,
    required this.clinicImagesPaths,
    required this.onClinicImagesChanged,
    required this.selectedDateOfBirth,
    required this.onDateOfBirthChanged,
    required this.selectedGender,
    required this.onGenderChanged,
    this.fieldErrors = const {},
  });

  final String? profilePicturePath;
  final ValueChanged<String?> onProfilePictureChanged;
  final List<String> clinicImagesPaths;
  final ValueChanged<List<String>> onClinicImagesChanged;

  @override
  State<DoctorSignUpForm> createState() => _DoctorSignUpFormState();
}

class _DoctorSignUpFormState extends State<DoctorSignUpForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _yearsFocus = FocusNode();
  final FocusNode _licenseFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();

  final FocusNode _hospitalFocus = FocusNode();
  final FocusNode _clinicFocus = FocusNode();
  final FocusNode _feeFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _nameFocus.dispose();
    _yearsFocus.dispose();
    _licenseFocus.dispose();
    _bioFocus.dispose();
    _hospitalFocus.dispose();
    _clinicFocus.dispose();
    _feeFocus.dispose();
    super.dispose();
  }

  /// Returns the server error message for a given field key, or null.
  String? _serverError(String key) => widget.fieldErrors[key.toLowerCase()];

  Widget _buildPasswordStrengthChecklist() {
    final password = widget.passwordController.text;
    if (password.isEmpty) return const SizedBox.shrink();

    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    bool hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    bool hasSpecial = RegExp(r'[\W_]').hasMatch(password);
    bool hasMinLength = password.length >= 8;

    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChecklistItem('Uppercase letter', hasUppercase),
          SizedBox(height: 4.h),
          _buildChecklistItem('Lowercase letter', hasLowercase),
          SizedBox(height: 4.h),
          _buildChecklistItem('Special character', hasSpecial),
          SizedBox(height: 4.h),
          _buildChecklistItem('8 characters', hasMinLength),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: isMet ? Colors.green : Colors.red,
          size: 16.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.step) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1() {
    return Column(
      children: [
        RegistrationTextField(
          label: 'Email Address',
          hintText: 'example@doctor.com',
          controller: widget.emailController,
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          validator: RegistrationValidators.validateEmail,
          serverError: _serverError('email'),
        ),
        SizedBox(height: 16.h),
        _buildPhoneField(),
        SizedBox(height: 16.h),
        RegistrationTextField(
          label: 'Password',
          hintText: 'Min. 8 characters',
          controller: widget.passwordController,
          focusNode: _passwordFocus,
          isPassword: true,
          prefixIcon: Icons.lock_outline_rounded,
          onChanged: (_) {
            setState(() {});
            widget.formKey.currentState?.validate();
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Password is required';
            }

            final passwordRegex = RegExp(
              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,}$',
            );

            if (!passwordRegex.hasMatch(value.trim())) {
              return 'Please meet all password requirements';
            }

            return null;
          },
          serverError: _serverError('password'),
        ),
        if (widget.passwordController.text.isNotEmpty) ...[
          SizedBox(height: 8.h),
          _buildPasswordStrengthChecklist(),
        ],
        SizedBox(height: 16.h),
        RegistrationTextField(
          label: 'Confirm Password',
          hintText: '••••••••',
          controller: widget.confirmPasswordController,
          focusNode: _confirmFocus,
          isPassword: true,
          prefixIcon: Icons.lock_reset_rounded,
          validator: (value) => RegistrationValidators.validateConfirmPassword(
            value,
            widget.passwordController.text,
          ),
          serverError: _serverError('confirmpassword'),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        ProfileImagePicker(
          imagePath: widget.profilePicturePath,
          onImageSelected: widget.onProfilePictureChanged,
        ),
        SizedBox(height: 24.h),
        RegistrationTextField(
          label: 'Full Name',
          hintText: 'Dr. John Doe',
          controller: widget.nameController,
          focusNode: _nameFocus,
          prefixIcon: Icons.person_outline_rounded,
          validator: (value) => RegistrationValidators.validateRequired(value, 'Full Name'),
          serverError: _serverError('fullname') ?? _serverError('fullName'),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: RegistrationDatePicker(
                label: 'Birth Date',
                selectedDate: widget.selectedDateOfBirth,
                onDateSelected: widget.onDateOfBirthChanged,
                hintText: 'MM/DD/YYYY',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: RegistrationDropdown(
                label: 'Gender',
                value: widget.selectedGender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: widget.onGenderChanged,
                hintText: 'Select Gender',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        RegistrationTextField(
          label: 'License ID',
          hintText: 'e.g. LIC-123456',
          controller: widget.licenseController,
          focusNode: _licenseFocus,
          prefixIcon: Icons.badge_outlined,
          validator: (value) => RegistrationValidators.validateRequired(value, 'License ID'),
          serverError:
              _serverError('licensenumber') ?? _serverError('licenseid'),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: RegistrationTextField(
                label: 'Exp. Years',
                hintText: '5',
                controller: widget.yearsController,
                focusNode: _yearsFocus,
                keyboardType: TextInputType.number,
                validator: RegistrationValidators.validateExperienceYears,
                serverError:
                    _serverError('yearsofexperience') ??
                    _serverError('experienceyears'),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: DoctorSpecializationField(
                selectedSpecialization: widget.selectedSpecialization,
                onChanged: widget.onSpecializationChanged,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        RegistrationTextField(
          label: 'Consultation Fee',
          hintText: 'e.g. 200',
          controller: widget.consultationFeeController,
          focusNode: _feeFocus,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.attach_money_rounded,
          validator: RegistrationValidators.validateConsultationFee,
          serverError: _serverError('consultationfee') ?? _serverError('consultationFee'),
        ),
        SizedBox(height: 16.h),
        RegistrationTextField(
          label: 'Professional Bio',
          hintText: 'Tell patients about your expertise...',
          controller: widget.bioController,
          focusNode: _bioFocus,
          maxLines: 3,
          validator: (value) => RegistrationValidators.validateRequired(value, 'Bio'),
          serverError: _serverError('bio'),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    final theme = Theme.of(context);
    return Column(
      children: [
        MultiImagePicker(
          imagePaths: widget.clinicImagesPaths,
          onImagesSelected: widget.onClinicImagesChanged,
        ),
        SizedBox(height: 24.h),
        RegistrationTextField(
          label: 'Main Hospital',
          hintText: 'e.g. Cairo Specialist Hospital',
          controller: widget.hospitalController,
          focusNode: _hospitalFocus,
          prefixIcon: Icons.local_hospital_outlined,
          validator: (value) => RegistrationValidators.validateRequired(value, 'Main Hospital'),
          suffixIcon: IconButton(
            icon: Icon(Icons.map_rounded, color: theme.colorScheme.primary),
            onPressed: widget.onShowHospitalLocationPicker,
          ),
          serverError: _serverError('hospital'),
        ),
        SizedBox(height: 16.h),
        RegistrationTextField(
          label: 'Clinic Address',
          hintText: 'Tap map icon to select',
          controller: widget.clinicAddressController,
          focusNode: _clinicFocus,
          prefixIcon: Icons.location_on_outlined,
          validator: (value) => RegistrationValidators.validateRequired(value, 'Clinic Address'),
          suffixIcon: IconButton(
            icon: Icon(Icons.map_rounded, color: theme.colorScheme.primary),
            onPressed: widget.onShowClinicLocationPicker,
          ),
          serverError: _serverError('clinicaddress'),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return RegistrationPhoneField(
      label: 'Phone Number',
      controller: widget.phoneController,
      focusNode: _phoneFocus,
      serverError: _serverError('phone'),
    );
  }
}
