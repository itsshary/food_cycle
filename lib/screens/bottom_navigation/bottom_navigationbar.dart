import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:food_cycle/screens/needy_person/complete_donation/complete_donation_screen.dart';
import 'package:food_cycle/screens/needy_person/needy_active_donation/needy_active_donation.dart';
import 'package:food_cycle/screens/needy_person/needy_chat_screen/chat_list_screen.dart';
import 'package:food_cycle/screens/needy_person/needy_home_screen/needy_home_screen.dart';
import 'package:food_cycle/screens/needy_person/profile_screen/profile_screen.dart';

import 'package:food_cycle/utils/color_resources.dart';
import 'package:food_cycle/utils/dimensions.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const NeedyHomeScreen(),
    const NeedyActiveDonation(),
    const CompleteDonationScreen(),
    const ChatListScreen(),
    const NeedyProfileScreen(),
  ];

  final List<TabItem> _navBarsItems = [
    const TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    const TabItem(
      icon: FontAwesomeIcons.handshakeAngle,
      title: 'Active',
    ),
    const TabItem(
      icon: FontAwesomeIcons.check,
      title: 'Complete',
    ),
    const TabItem(
      icon: Icons.chat,
      title: 'Chat',
    ),
    const TabItem(
      icon: Icons.person,
      title: 'Account',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            left: Dimensions.paddingSizeSmall12,
            right: Dimensions.paddingSizeSmall12,
            bottom: Dimensions.paddingSizeSmall10),
        child: BottomBarFloating(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          items: _navBarsItems,
          backgroundColor: const Color.fromARGB(255, 12, 131, 16),
          color: ColorResources.whiteColor,
          colorSelected: ColorResources.amberColor,
          indexSelected: _currentIndex,
          onTap: (int index) => setState(() {
            _currentIndex = index;
          }),
        ),
      ),
    );
  }
}
