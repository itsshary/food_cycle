import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hintText) {
  return InputDecoration(
    focusColor: Colors.green,
    focusedBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(style: BorderStyle.solid, color: Colors.green),
        borderRadius: BorderRadius.circular(10.0)),
    fillColor: Colors.green.shade100,
    hintText: hintText,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
