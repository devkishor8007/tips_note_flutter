import 'package:flutter/material.dart';

Widget buildTextFormFieldWidget(
    {TextEditingController? controller,
    String? hintText,
    bool? obscureText,
    TextInputType? keyboardType,
    int? maxLines,
    int? maxLength,
    String? Function(String?)? validator}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText ?? false,
    validator: validator,
    keyboardType: keyboardType ?? TextInputType.text,
    maxLines: maxLines ?? 1,
    maxLength: maxLength ?? 30,
    decoration: InputDecoration(
      hintText: hintText ?? "Enter email",
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red.withOpacity(0.6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
