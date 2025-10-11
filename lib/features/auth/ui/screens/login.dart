import 'package:doctor_appointment/features/auth/ui/widgets/auth_header_text.dart';
import 'package:doctor_appointment/features/auth/ui/widgets/auth_login_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              spacing: 32,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AuthHeaderText(
                  title: 'Welcome Back',
                  subtitle:
                      'We\'re excited to have you back, can\'t wait to see what you\'ve been up to since you last logged in.',
                ),
                AuthLoginBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
