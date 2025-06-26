import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:food_cycle/admin_panel/active_donations/admin_active_donations.dart';
import 'package:food_cycle/admin_panel/completed_donations/admin_completed_donations.dart';
import 'package:food_cycle/admin_panel/dashboard/dashboard_screen.dart';
import 'package:food_cycle/admin_panel/donation_chart_screen/donation_chart_screen.dart';
import 'package:food_cycle/admin_panel/donations/all_donations.dart';
import 'package:food_cycle/admin_panel/pending_users/pending_users.dart';
import 'package:food_cycle/utils/color_resources.dart';

class WebMainScreen extends StatefulWidget {
  static const String id = 'webmain';
  const WebMainScreen({super.key});

  @override
  State<WebMainScreen> createState() => _WebMainScreenState();
}

class _WebMainScreenState extends State<WebMainScreen> {
  Widget selectedScreen = const DashboardScreen();
  String _selectedRoute = DashboardScreen.id; // Track selected screen

  void chooseScreen(String item) {
    setState(() {
      _selectedRoute = item; // Update selected route
      switch (item) {
        case DashboardScreen.id:
          selectedScreen = const DashboardScreen();
          break;
        case PendingUsers.id:
          selectedScreen = const PendingUsers();
          break;
        case AllDonations.id:
          selectedScreen = const AllDonations();
          break;
        case AdminActiveDonations.id:
          selectedScreen = const AdminActiveDonations();
          break;
        case AdminCompletedDonations.id:
          selectedScreen = const AdminCompletedDonations();
          break;
        case DonationChartScreen.id:
          selectedScreen = DonationChartScreen();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.green.shade100,
      sideBar: SideBar(
        selectedRoute: _selectedRoute,
        textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        backgroundColor: ColorResources.primaryColor,
        onSelected: (item) => chooseScreen(item.route!),
        items: [
          _buildMenuItem("Dashboard", Icons.dashboard, DashboardScreen.id),
          _buildMenuItem(
              "Pending Users", Icons.lock_clock_rounded, PendingUsers.id),
          _buildMenuItem("All Donations", Icons.food_bank, AllDonations.id),
          _buildMenuItem(
              "Active Donations", Icons.access_time, AdminActiveDonations.id),
          _buildMenuItem(
              "Completed Donations", Icons.done, AdminCompletedDonations.id),
          _buildMenuItem(
              "Donation Chart", Icons.food_bank, DonationChartScreen.id),
        ],
      ),
      body: selectedScreen,
    );
  }

  AdminMenuItem _buildMenuItem(String title, IconData icon, String route) {
    return AdminMenuItem(
      title: title,
      icon: icon,
      route: route,
    );
  }
}















// import 'package:flutter/material.dart';
// import 'package:flutter_admin_scaffold/admin_scaffold.dart';



// import 'package:food_cycle/admin_panel/active_donations/admin_active_donations.dart';
// import 'package:food_cycle/admin_panel/completed_donations/admin_completed_donations.dart';
// import 'package:food_cycle/admin_panel/dashboard/dashboard_screen.dart';
// import 'package:food_cycle/admin_panel/donations/all_donations.dart';
// import 'package:food_cycle/admin_panel/pending_users/pending_users.dart';
// import 'package:food_cycle/resources/constants/appcolors.dart';

// class WebMainScreen extends StatefulWidget {
//   static const String id = 'webmain';
//   const WebMainScreen({super.key});

//   @override
//   State<WebMainScreen> createState() => _WebMainScreenState();
// }

// class _WebMainScreenState extends State<WebMainScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return AdminScaffold(
//       backgroundColor: Colors.green.shade100,
//       sideBar: SideBar(
//           activeBackgroundColor: Colors.black,
          
//           textStyle: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
//           backgroundColor: Appcolors.primaryColor,
//           onSelected: (item) {
//             chooseScreen(item.route);
//           },
//           items: const [
//             AdminMenuItem(
//                 title: "DashBoard",
//                 icon: Icons.dashboard,
//                 route: DashboardScreen.id),
//             AdminMenuItem(
//                 title: "Pending User's",
//                 icon: Icons.lock_clock_rounded,
//                 route: PendingUsers.id),
//             AdminMenuItem(
//                 title: "All Donation's",
//                 icon: Icons.food_bank,
//                 route: AllDonations.id),
//             AdminMenuItem(
//                 title: "All Active Donation's",
//                 icon: Icons.access_time,
//                 route: AdminActiveDonations.id),
//             AdminMenuItem(
//                 title: "Completed Donation's",
//                 icon: Icons.done,
//                 route: AdminCompletedDonations.id),
//           ],
//           selectedRoute: WebMainScreen.id),
//       body: selectedScree,
//     );
//   }

//   Widget selectedScree = const DashboardScreen();
//   chooseScreen(item) {
//     switch (item) {
//       case DashboardScreen.id:
//         setState(() {
//           selectedScree = const DashboardScreen();
//         });
//         break;
//       case PendingUsers.id:
//         setState(() {
//           selectedScree = const PendingUsers();
//         });
//         break;
//       case AllDonations.id:
//         setState(() {
//           selectedScree = const AllDonations();
//         });
//         break;
//       case AdminActiveDonations.id:
//         setState(() {
//           selectedScree = const AdminActiveDonations();
//         });
//         break;
//       case AdminCompletedDonations.id:
//         setState(() {
//           selectedScree = const AdminCompletedDonations();
//         });
//         break;

//       default:
//     }
//   }
// }
