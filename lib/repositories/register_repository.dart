import 'package:food_cycle/notification/notification_service/notification_service_screen_logic.dart';
import 'package:food_cycle/services/register_service.dart';

import '../models/user_model.dart';

import '../services/firestore_service.dart';

class RegisterRepository {
  final RegisterService _authService;
  final FirestoreService _firestoreService;
  final NotificationServiceScreenLogic _notificationService;

  RegisterRepository(
    this._authService,
    this._firestoreService,
    this._notificationService,
  );

  Future<(UserModel, String)> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String role,
  }) async {
    final token = await _notificationService.getDeviceToken();
    final userCredential = await _authService.registerUser(email, password);
    final uid = userCredential.user!.uid;

    final user = UserModel(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      role: role,
      donatorId: role == 'Donater' ? uid : '',
      needyId: role == 'Needy' ? uid : '',
      createdAt: DateTime.now(),
      userStatus: "Pending",
      location: "",
      deviceToken: token,
      image: "",
      rating: 0,
    );

    await _firestoreService.saveUser(user);
    final status = await _firestoreService.getUserStatus(uid);

    return (user, status);
  }
}
