import 'package:doctor_appointment/core/themes/styles.dart';
import 'package:flutter/material.dart';

class AuthLoginTermsAndConditions extends StatelessWidget {
  const AuthLoginTermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'By logging, you agree to our ',
            style: TextStyles.font12LightGrayRegular.copyWith(height: 1.8),
          ),
          TextSpan(
            text: 'Terms & Conditions ',
            style: TextStyles.font12LightBlackBold.copyWith(height: 1.5),
          ),
          TextSpan(
            text: 'and ',
            style: TextStyles.font12LightGrayRegular.copyWith(height: 1.8),
          ),
          TextSpan(
            text: 'PrivacyPolicy.',
            style: TextStyles.font12LightBlackBold.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
