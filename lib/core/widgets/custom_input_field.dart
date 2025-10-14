import 'package:doctor_appointment/core/themes/colors_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputFormField extends StatelessWidget {
  const CustomInputFormField({
    super.key,
    required this.name,
    this.icon,
    this.obscure = false,
    this.onSaved,
    required this.validator,
  });
  final void Function(String?)? onSaved;
  final String name;
  final Widget? icon;
  final bool obscure;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      obscureText: obscure,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.border),
          borderRadius: BorderRadius.circular(16.r),
        ),
        suffixIcon: icon,
        filled: true,
        hintText: name,
        focusedBorder: customBorder(ColorsManager.primary_100),
        errorBorder: customBorder(ColorsManager.secondaryRed),
        fillColor: ColorsManager.secondaryForm,
        contentPadding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 16.w),
      ),
    );
  }
}

InputBorder customBorder(Color color) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 2),
    borderRadius: BorderRadius.circular(16.r),
  );
}
