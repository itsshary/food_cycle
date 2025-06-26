import 'package:flutter/material.dart';
import 'package:food_cycle/provider/fetch_badges_count.dart';
import 'package:food_cycle/screens/needy_person/needy_home_screen/widgets/icon_button.dart';
import 'package:food_cycle/utils/color_resources.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BadgeProvider>(
      builder: (context, badgeProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: badges.Badge(
            badgeStyle: const badges.BadgeStyle(
                badgeColor: ColorResources.primaryColor),
            position: badges.BadgePosition.topEnd(end: 3, top: 0),
            badgeContent: Text(
              "${badgeProvider.badgeCount}",
              style: const TextStyle(color: ColorResources.whiteColor),
            ),
            child: const MyIconButton(),
          ),
        );
      },
    );
  }
}
