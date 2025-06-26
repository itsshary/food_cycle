// view_models/view_categories_view_model.dart
import 'package:flutter/material.dart';
import 'package:food_cycle/repositories/fetch_catagory_rep.dart';
import '../models/donation_model.dart';

class ViewCategoriesViewModel extends ChangeNotifier {
  final DonationRepository _repository = DonationRepository();

  Stream<List<DonationModel>> getDonations(String category) {
    return _repository.getDonationsByCategory(category).map((snapshot) {
      return snapshot.docs.map<DonationModel>((doc) {
        return DonationModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<Map<String, dynamic>> getUserData(String uid) {
    return _repository.getUserData(uid);
  }
}
