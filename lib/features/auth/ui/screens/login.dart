import 'package:doctor_appointment/features/auth/ui/widgets/auth_header.dart';
import 'package:doctor_appointment/features/auth/ui/widgets/auth_login_body.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 32,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AuthHeader(
            title: 'Welcome Back',
            subtitle:
                'We\'re excited to have you back, can\'t wait to see what you\'ve been up to since you last logged in.',
          ),
          AuthLoginBody(),
        ],
      ),
    );
  }
}
