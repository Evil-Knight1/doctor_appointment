import 'package:doctor_appointment/core/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthLoginBody extends StatefulWidget {
  const AuthLoginBody({super.key});

  @override
  State<AuthLoginBody> createState() => _AuthLoginBodyState();
}

class _AuthLoginBodyState extends State<AuthLoginBody> {
  final bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  IconData _icon = Icons.remove_red_eye;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              spacing: 16.h,
              children: [
                CustomInputFormField(
                  name: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email Required';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                CustomInputFormField(
                  name: 'Password',
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'At least 6 characters';
                    }
                    return null;
                  },
                  icon: IconButton(
                    icon: Icon(_icon),
                    onPressed: () => {
                      setState(
                        () => _icon = _icon == Icons.remove_red_eye
                            ? Icons.abc
                            : Icons.remove_red_eye,
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
