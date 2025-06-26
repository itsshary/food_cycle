import 'package:flutter/material.dart';
import 'package:food_cycle/utils/app_constants.dart';
import 'package:food_cycle/utils/images.dart';

import '../../../../utils/color_resources.dart';

class AppbarWidget extends StatelessWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AppImages.logo,
          width: 40,
          height: 40,
        ),
        const Text(
          AppConstants.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: ColorResources.whiteColor,
          ),
        ),
      ],
    );
  }
}
