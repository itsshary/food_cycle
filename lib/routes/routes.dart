import 'package:flutter/material.dart';
import 'package:food_cycle/routes/routes_name.dart';
import 'package:food_cycle/screens/auth_screen/forget_password_screen/forget_password_screen.dart';
import 'package:food_cycle/screens/auth_screen/login_screen/login_screen.dart';
import 'package:food_cycle/screens/auth_screen/register_screen/register_screen.dart';
import 'package:food_cycle/screens/donater_screen/donater_home_screen.dart';
import 'package:food_cycle/screens/needy_person/filteration/filter_screen.dart';
import 'package:food_cycle/screens/needy_person/needy_home_screen/needy_home_screen.dart';
import 'package:food_cycle/screens/notification_screen/notification_screen.dart';
import 'package:food_cycle/screens/splash_screen/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routesname.splashScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case Routesname.needyHomeScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const NeedyHomeScreen());
      case Routesname.donatorHomeScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DonaterHomeScreen());
      case Routesname.forgetPasswordScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ForgetPasswordScreen());

      case Routesname.loginScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case Routesname.registerScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RegisterScreen());
      case Routesname.notificationScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => NotificationScreen());
      case Routesname.filterSearchScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FilterSearchScreen());

      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Scaffold(
                  body: Center(
                    child: Text("No Routes Defines"),
                  ),
                ));
    }
  }
}
