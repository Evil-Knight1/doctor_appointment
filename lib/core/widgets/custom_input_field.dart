import 'package:doctor_appointment/core/themes/colors_manger.dart';
import 'package:doctor_appointment/core/themes/styles.dart';
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
      style: TextStyles.font14LightBlackRegular.copyWith(height: 1.5),
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
        suffixIcon: icon,
        filled: true,
        hintText: name,
        hintStyle: TextStyles.font14BodyRegular,
        focusedBorder: customBorder(ColorsManager.primary_100),
        errorBorder: customBorder(ColorsManager.secondaryRed),
        fillColor: ColorsManager.lightWhite,
        contentPadding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 20.w),
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
