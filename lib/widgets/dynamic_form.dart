import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/form_field_config.dart';

class DynamicForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<FormFieldConfig> fields;
  final String submitButtonText;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String? errorMessage;
  final Widget? additionalContent;
  final EdgeInsets? padding;

  const DynamicForm({
    super.key,
    required this.formKey,
    required this.fields,
    required this.submitButtonText,
    required this.onSubmit,
    this.isLoading = false,
    this.errorMessage,
    this.additionalContent,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ...fields.map((field) => _buildField(field)),
          if (additionalContent != null) ...[
            additionalContent!,
            const SizedBox(height: 16),
          ],
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildField(FormFieldConfig field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.labelPosition == LabelPosition.outside)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(field.label, style: AppTheme.bodyMedium),
            ),
          TextFormField(
            controller: field.controller,
            style: AppTheme.bodyLarge.copyWith(color: Colors.white),
            validator: field.validator,
            obscureText: field.obscureText,
            decoration: InputDecoration(
              labelText:
                  field.labelPosition == LabelPosition.inside
                      ? field.label
                      : null,
              hintText: field.hint,
              hintStyle: const TextStyle(color: Colors.white70),
              suffixIcon: field.suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.white),
              ),
              filled: true,
              fillColor: const Color(0xFF2A2F3D),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child:
          isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                submitButtonText,
                style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
    );
  }
}
