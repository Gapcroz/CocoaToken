import 'package:flutter/material.dart';

enum LabelPosition {
  inside, // Label dentro del input
  outside, // Label fuera del input
  none, // Sin label
}

class FormFieldConfig {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;
  final LabelPosition labelPosition;

  FormFieldConfig({
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.labelPosition = LabelPosition.inside,
  });
}
