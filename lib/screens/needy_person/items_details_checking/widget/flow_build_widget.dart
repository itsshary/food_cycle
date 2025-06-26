import 'package:flutter/material.dart';

Widget buildInfoRow(IconData icon, String label, String value,
    {bool isDescription = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment:
          isDescription ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: isDescription ? 5 : 1,
            overflow:
                isDescription ? TextOverflow.ellipsis : TextOverflow.visible,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
