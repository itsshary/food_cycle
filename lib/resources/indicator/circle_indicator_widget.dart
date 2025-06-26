import 'package:flutter/material.dart';
import 'package:food_cycle/utils/color_resources.dart';

class CircleIndicatorWidget extends StatelessWidget {
  const CircleIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(
      color: ColorResources.primaryColor,
    ));
  }
}
