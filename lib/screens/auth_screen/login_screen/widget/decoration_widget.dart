import 'package:flutter/material.dart';

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
    focusColor: Colors.green,
    focusedBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(style: BorderStyle.solid, color: Colors.green),
        borderRadius: BorderRadius.circular(10.0)),
    fillColor: Colors.green.shade100,
    filled: true,
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
  );
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 6) return 'Password must be at least 6 characters long';
  return null;
}
