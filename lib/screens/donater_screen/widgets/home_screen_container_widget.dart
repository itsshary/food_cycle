import 'package:flutter/material.dart';
import 'package:food_cycle/utils/app_textstyle.dart';

class HomeScreenContainerWidget extends StatelessWidget {
  final Color color;
  final String textchild;
  final String text;

  const HomeScreenContainerWidget({
    super.key,
    required this.color,
    required this.textchild,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: color,
          ),
          child: Center(
            child: Text(
              textchild,
              style: AppTextstyle()
                  .commontextstylebalckcolor
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
