// ViewModel: filter_search_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterSearchViewModel extends ChangeNotifier {
  List<DocumentSnapshot> _filteredDonations = [];
  List<DocumentSnapshot> get filteredDonations => _filteredDonations;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> applyFilters(Map<String, dynamic> filters) async {
    try {
      final query = _firestore
          .collection('donations')
          .where('foodType', isEqualTo: filters['foodType'])
          .where('deliveryType', isEqualTo: filters['deliveryType'])
          .where('distance', isEqualTo: filters['distance']);

      final result = await query.get();
      _filteredDonations = result.docs;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to fetch filtered donations: $e");
    }
  }
}