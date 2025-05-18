import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import '../utils/app_text_style.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.onSaved,
    this.obobscureText = false, // Corrected typo here
    this.controller,
    this.validator,
    this.prefixIcon,
    this.onSubmitted,
    this.onChanged,
    required this.keyboardType,
  });

  final String hintText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String?)? onSaved;
  final bool obobscureText; // Corrected typo here
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onSubmitted; // Added this parameter
  final void Function(String)? onChanged; // Added this parameter

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyles.semiBold13.copyWith(color: Colors.grey.shade900),
      controller: controller,
      onChanged: onChanged,
      obscureText: obobscureText,
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: AppColors.textColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        border: buildBorder(),
        errorBorder: buildBorder(),
        enabledBorder: buildBorder(),
        focusedErrorBorder: focusedErrorBorder(),
        focusedBorder: buildBorder(),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1, color: Colors.black),
    );
  }

  OutlineInputBorder focusedErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.fabBackgroundColor,
      ),
    );
  }
}
