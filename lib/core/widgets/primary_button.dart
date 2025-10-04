import 'package:doctor_appointment/core/themes/colors_manger.dart';
import 'package:doctor_appointment/core/themes/styles.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding = const EdgeInsets.all(16),
  });
  final String text;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: WidgetStateProperty.all(ColorsManager.primary_100),
          foregroundColor: WidgetStateProperty.all(ColorsManager.white),
          minimumSize: WidgetStateProperty.all(const Size(double.infinity, 52)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Text(text, style: TextStyles.font16White700W),
          ),
        ),
      ),
    );
  }
}
