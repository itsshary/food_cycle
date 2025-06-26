import 'package:flutter/material.dart';
import 'package:food_cycle/screens/donater_screen/chat_modules/main_screen_chat.dart';
import 'package:food_cycle/screens/donater_screen/donater_home_screen.dart';
import 'package:food_cycle/screens/donater_screen/donater_profile_screen.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:food_cycle/screens/donater_screen/upload_donation_screen.dart';

class DonaterBottomBar extends StatefulWidget {
  const DonaterBottomBar({Key? key}) : super(key: key);

  @override
  _DonaterBottomBarState createState() => _DonaterBottomBarState();
}

class _DonaterBottomBarState extends State<DonaterBottomBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DonaterHomeScreen(),
    const UploadDonationScreen(),
    const ChatMainScreen(),
    const DonaterProfileScreen(),
  ];

  final List<TabItem> _navBarsItems = [
    const TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    const TabItem(
      icon: Icons.upload,
      title: 'Upload Donation',
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
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 10.0),
        child: BottomBarFloating(
          borderRadius: BorderRadius.circular(30.0),
          items: _navBarsItems,
          backgroundColor: Colors.black,
          color: Colors.white,
          colorSelected: Colors.green,
          indexSelected: _currentIndex,
          onTap: (int index) => setState(() {
            _currentIndex = index;
          }),
        ),
      ),
    );
  }
}
