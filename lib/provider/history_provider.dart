import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math_ai/view/history/database_helper.dart';

class HistoryProvider extends ChangeNotifier {
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  void updateSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  String _selectedFilter = "All History";
  String get selectedFilter => _selectedFilter;

  void changeFilter(String value) {
    _selectedFilter = value;
    notifyListeners();
  }

  // ================= FIREBASE STREAM =================
  Stream<QuerySnapshot> get historyStream => DatabaseHelper.getHistory();

  // ================= SEARCH FILTERING ON STREAM =================
  Stream<QuerySnapshot> get filteredHistoryStream {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _searchQuery.isEmpty) {
      return DatabaseHelper.getHistory();
    }

    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("history")
        .where("searchText", arrayContains: _searchQuery.toLowerCase())
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
