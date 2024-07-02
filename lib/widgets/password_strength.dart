import 'package:flutter/material.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class PasswordStrengthWidget extends StatefulWidget {
  final TextEditingController passwordController;
  const PasswordStrengthWidget({super.key, required this.passwordController});

  @override
  State<PasswordStrengthWidget> createState() => _PasswordStrengthWidgetState();
}

class _PasswordStrengthWidgetState extends State<PasswordStrengthWidget> {
  bool _isPasswordValid = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlutterPwValidator(
          width: AppConstants.screenWidth * 0.9,
          height: AppConstants.screenHeight * 0.28,
          minLength: 8,
          uppercaseCharCount: 2,
          specialCharCount: 1,
          numericCharCount: 2,
          controller: widget.passwordController,
          onSuccess: () {
            setState(() {
              _isPasswordValid = true;
            });
          },
          onFail: () {
            setState(() {
              _isPasswordValid = false;
            });
          },
        ),
        SizedBox(height: AppConstants.sizedBoxHeightMedium),
      ],
    );
  }
}
