import 'package:flutter/material.dart';

Widget buildCard({required List<Widget> children}) {
  return Card(
    color: const Color.fromARGB(255, 223, 240, 224),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 6, // Increased elevation for better shadow
    shadowColor: Colors.grey.withOpacity(0.5), // Added shadow color
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(children: children),
    ),
  );
}
