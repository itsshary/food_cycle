import 'package:flutter/material.dart';
import 'package:food_cycle/screens/auth_screen/login_screen/login_screen.dart';
import 'package:food_cycle/screens/bottom_navigation/bottom_navigationbar.dart';
import 'package:food_cycle/screens/donater_screen/donater_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:food_cycle/screens/on_boarding_screens/onboarding_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool('onboardingSeen') ?? false;

    if (!onboardingSeen) {
      // Show onboarding only once
      await prefs.setBool('onboardingSeen', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      // Logged in - check user role
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = snapshot.data()?['role'];

      if (role == 'Needy') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomBottomBar()),
        );
      } else if (role == 'Donater') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DonaterBottomBar()),
        );
      } else {
        // Unknown role fallback
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/1.png',
          height: height * 0.3,
          width: width * 0.5,
        ),
      ),
    );
  }
}
