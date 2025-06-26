import 'package:flutter/material.dart';

class FoodItemRow extends StatelessWidget {
  final String foodItem;
  final String foodvalue;

  const FoodItemRow(
      {super.key, required this.foodItem, required this.foodvalue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$foodvalue: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              foodItem,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
