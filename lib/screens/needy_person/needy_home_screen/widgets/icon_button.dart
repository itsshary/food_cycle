import 'package:flutter/material.dart';
import 'package:food_cycle/routes/routes_name.dart';
import 'package:food_cycle/utils/color_resources.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, Routesname.notificationScreen);
      },
      icon: const Icon(
        Icons.notifications,
        color: ColorResources.whiteColor,
        size: 35.0,
      ),
    );
  }
}
