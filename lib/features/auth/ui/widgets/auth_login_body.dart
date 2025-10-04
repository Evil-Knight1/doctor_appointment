import 'package:doctor_appointment/core/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';

class AuthLoginBody extends StatelessWidget {
  const AuthLoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            
          ),
          CustomInputField(name: 'Email'),
          CustomInputField(name: 'Password'),
        ],
      ),
    );
  }
}
