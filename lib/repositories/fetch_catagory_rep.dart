// repositories/donation_repository.dart
import 'package:food_cycle/services/get_catagery_service.dart';

class DonationRepository {
  final GetCatageryService _firestoreService = GetCatageryService();

  Stream getDonationsByCategory(String category) {
    return _firestoreService.getDonationsByCategory(category);
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    final doc = await _firestoreService.getUserById(uid);
    return doc.data() as Map<String, dynamic>;
  }
}
