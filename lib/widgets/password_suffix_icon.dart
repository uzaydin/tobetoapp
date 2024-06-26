import 'package:flutter/material.dart';

class PasswordSuffixIcon extends StatefulWidget {
  final bool isPasswordVisible;
  final VoidCallback onToggleVisibility;
  const PasswordSuffixIcon(
      {super.key,
      required this.isPasswordVisible,
      required this.onToggleVisibility});

  @override
  State<PasswordSuffixIcon> createState() => _PasswordSuffixiconState();
}

class _PasswordSuffixiconState extends State<PasswordSuffixIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggleVisibility,
      child: Icon(
        widget.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
      ),
    );
  }
}
