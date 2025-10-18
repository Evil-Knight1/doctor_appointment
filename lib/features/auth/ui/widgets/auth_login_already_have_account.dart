import 'package:doctor_appointment/core/helpers/extensions.dart';
import 'package:doctor_appointment/core/routes/routes.dart';
import 'package:doctor_appointment/core/themes/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthLoginAlreadyHaveAccount extends StatelessWidget {
  const AuthLoginAlreadyHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account yet?',
            style: TextStyles.font12LightBlackRegular,
          ),
          TextSpan(
            text: ' Sing Up',
            style: TextStyles.font12BlueBold,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.pushName(Routes.register);
              },
          ),
        ],
      ),
    );
  }
}
