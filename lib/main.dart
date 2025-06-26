import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/admin_panel/donations/all_donations.dart';
import 'package:food_cycle/admin_panel/pending_users/pending_users.dart';
import 'package:food_cycle/admin_panel/web_main_screen.dart';
import 'package:food_cycle/firebase_options.dart';
import 'package:food_cycle/notification/notification_service/notification_service_screen_logic.dart';
import 'package:food_cycle/provider/donation_datails_vm.dart';
import 'package:food_cycle/provider/fetch_badges_count.dart';
import 'package:food_cycle/provider/forget_password_vm.dart';
import 'package:food_cycle/provider/login_vm.dart';
import 'package:food_cycle/provider/needy_profile_vm.dart';
import 'package:food_cycle/provider/needy_update_profile_viewmodel.dart';
import 'package:food_cycle/provider/register_viewmodel.dart';
import 'package:food_cycle/repositories/register_repository.dart';
import 'package:food_cycle/routes/routes.dart';
import 'package:food_cycle/routes/routes_name.dart';
import 'package:food_cycle/screens/splash_screen/splash_screen.dart';
import 'package:food_cycle/services/firestore_service.dart';
import 'package:food_cycle/services/register_service.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    subscribeBasedOnRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ForgetPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => NeedyUpdateProfileViewmodel()),
        ChangeNotifierProvider(create: (_) => NeedyProfileViewModel()),
        ChangeNotifierProvider(create: (_) => DonationDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(
            create: (_) => RegisterViewModel(RegisterRepository(
                RegisterService(),
                FirestoreService(),
                NotificationServiceScreenLogic()))),
        ChangeNotifierProvider(
          create: (_) => BadgeProvider(
            userId: FirebaseAuth.instance.currentUser!.uid.toString(),
          ),
        ),
      ],
      child: MaterialApp(
        initialRoute: Routesname.splashScreen,
        onGenerateRoute: Routes.generateRoutes,
        debugShowCheckedModeBanner: false,
        routes: {
          WebMainScreen.id: (context) => const WebMainScreen(),
          PendingUsers.id: (context) => const PendingUsers(),
          AllDonations.id: (context) => const AllDonations(),
        },
        home: kIsWeb ? const WebMainScreen() : const SplashScreen(),
      ),
    );
  }
}

// subscribe any specific channal the we will used this function
// you can also fetch the role and send notification

// send notification with specific topic we will used this
void subscribeBasedOnRole() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid == null) {
    print("User not logged in.");
    return;
  }

  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final role = userDoc.get('role');
      if (role == 'Needy') {
        await FirebaseMessaging.instance.subscribeToTopic('Needy');
        print("Subscribed to 'needy' topic.");
      } else {
        print("User role is not Needy. No subscription done.");
      }
    } else {
      print("User document not found.");
    }
  } catch (e) {
    print("Error subscribing to topic: $e");
  }
}

// void subscribe() {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   messaging.subscribeToTopic('needy');
// }
