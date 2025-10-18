import 'package:doctor_appointment/core/themes/colors_manger.dart';
import 'package:doctor_appointment/core/themes/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_button.dart';
import 'package:doctor_appointment/core/widgets/custom_input_field.dart';
import 'package:doctor_appointment/features/auth/ui/widgets/auth_header_text.dart';
import 'package:doctor_appointment/features/auth/ui/widgets/auth_login_already_have_account.dart';
import 'package:doctor_appointment/features/auth/ui/widgets/auth_login_terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  IconData _icon = Icons.visibility;
  bool _isObscureText = true;
  bool _rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              spacing: 36.h,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AuthHeaderText(
                  title: 'Welcome Back',
                  subtitle:
                      'We\'re excited to have you back, can\'t wait to see what you\'ve been up to since you last logged in.',
                ),
                SizedBox(height: 10.h),
                Form(
                  key: _formKey,
                  child: Column(
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
                      SizedBox(height: 16.h),
                      CustomInputFormField(
                        obscure: _isObscureText,
                        name: 'Password',
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'At least 6 characters';
                          }
                          return null;
                        },
                        icon: IconButton(
                          color: ColorsManager.primary_100,
                          icon: Icon(_icon),
                          onPressed: () => {
                            setState(() {
                              _isObscureText = !_isObscureText;
                              _icon = _isObscureText == true
                                  ? Icons.visibility
                                  : Icons.visibility_off;
                            }),
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (val) => {
                              setState(() {
                                _rememberMe = val!;
                              }),
                            },
                          ),
                          Text(
                            'Remember me',
                            style: TextStyles.font12BodyRegular,
                          ),
                          Spacer(),
                          Text(
                            'Forgot Password?',
                            style: TextStyles.font12BlueRegular,
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),
                      CustomButton(text: 'Login', onPressed: () => {}),
                    ],
                  ),
                ),
                AuthLoginTermsAndConditions(),
                AuthLoginAlreadyHaveAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
