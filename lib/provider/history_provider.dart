import 'package:flutter/material.dart';
import 'package:math_ai/models/hive_model.dart';
import 'package:math_ai/view/historyscreen/database_helper.dart';

class HistoryProvider extends ChangeNotifier {
  // ================= SEARCH =================
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  void updateSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  // ================= FILTER =================
  String _selectedFilter = "All History";
  String get selectedFilter => _selectedFilter;

  void changeFilter(String value) {
    _selectedFilter = value;
    notifyListeners();
  }

  // ================= GET ALL HISTORY =================
  List<HistoryModel> get historyList => DatabaseHelper.getHistory();

  // ================= ADD HISTORY =================
  Future<void> addHistory(HistoryModel model) async {
    await DatabaseHelper.saveHistory(model);
    notifyListeners(); // ← rebuilds UI after adding
  }

  // ================= DELETE HISTORY =================
  Future<void> deleteHistory(int index) async {
    await DatabaseHelper.deleteHistory(index);
    notifyListeners(); // ← rebuilds UI after deleting
  }

  void removeHistoryAt(int index) {
    DatabaseHelper.deleteHistory(index);
    notifyListeners();
  }

  // ================= CLEAR ALL HISTORY =================
  Future<void> clearHistory() async {
    await DatabaseHelper.clearHistory();
    notifyListeners();
  }

  // ================= FILTERED HISTORY =================
  List<HistoryModel> get filteredHistory {
    final query = _searchQuery.toLowerCase();

    return historyList.where((item) {
      final categoryMatch =
          _selectedFilter == "All History" || item.category == _selectedFilter;

      final searchMatch =
          query.isEmpty || item.searchText.toLowerCase().contains(query);

      return categoryMatch && searchMatch;
    }).toList();
  }
}
