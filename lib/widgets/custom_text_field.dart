import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.validator,
    this.maxLines = 1,
    this.fillColor,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final resolvedFillColor = fillColor ??
        (isDark
            ? theme.colorScheme.surfaceContainer
            : theme.colorScheme.onSurface.withValues(alpha: 0.05));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          maxLines: isPassword ? 1 : maxLines,
          inputFormatters: inputFormatters,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            prefixIcon: Icon(
              icon,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: resolvedFillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: isDark ? 0.25 : 0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: isDark ? 0.25 : 0.08),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.secondary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
