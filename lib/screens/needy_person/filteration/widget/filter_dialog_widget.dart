
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  double _maxDistance = 5;
  String _selectedFoodType = "Fresh";
  String _selectedDeliveryType = "Delivery";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filter Donations"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Max Distance (km)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _maxDistance,
              min: 0,
              max: 15,
              divisions: 15,
              label: "${_maxDistance.round()} km",
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  _maxDistance = value;
                });
              },
            ),
            const SizedBox(height: 12),
            const Text("Food Type",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: ["Fresh", "Frozen", "Canned", "Else"]
                  .map((type) => ChoiceChip(
                        selectedColor: Colors.green.shade200,
                        label: Text(type),
                        selected: _selectedFoodType == type,
                        onSelected: (_) {
                          setState(() {
                            _selectedFoodType = type;
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            const Text("Delivery Type",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: ["Delivery", "Pickup"]
                  .map((method) => ChoiceChip(
                        selectedColor: Colors.green.shade200,
                        label: Text(method),
                        selected: _selectedDeliveryType == method,
                        onSelected: (_) {
                          setState(() {
                            _selectedDeliveryType = method;
                          });
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              "distance": _maxDistance,
              "foodType": _selectedFoodType,
              "deliveryType": _selectedDeliveryType,
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text(
            "Apply",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
