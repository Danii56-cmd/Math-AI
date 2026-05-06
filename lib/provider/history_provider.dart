import 'package:flutter/material.dart';
import 'package:math_ai/models/hive_model.dart';
import 'package:math_ai/view/historyscreen/database_helper.dart';

class HistoryProvider extends ChangeNotifier {
  List<HistoryModel> _history = [];

  List<HistoryModel> get historyList => _history;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  String _selectedFilter = "All History";
  String get selectedFilter => _selectedFilter;

  // INIT LOAD
  Future<void> loadHistory() async {
    _history = DatabaseHelper.getHistory();
    notifyListeners();
  }

  // ADD
  Future<void> addHistory(HistoryModel model) async {
    await DatabaseHelper.saveHistory(model);
    await loadHistory(); // 🔥 important
  }

  // DELETE
  Future<void> deleteHistory(dynamic key) async {
    await DatabaseHelper.deleteHistory(key);
    await loadHistory(); // 🔥 important
  }

  // CLEAR
  Future<void> clearHistory() async {
    await DatabaseHelper.clearHistory();
    await loadHistory(); // 🔥 important
  }

  // SEARCH
  void updateSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  // FILTER
  void changeFilter(String value) {
    _selectedFilter = value;
    notifyListeners();
  }

  // FILTERED DATA
  List<HistoryModel> get filteredHistory {
    final query = _searchQuery.toLowerCase();

    return _history.where((item) {
      final categoryMatch =
          _selectedFilter == "All History" || item.category == _selectedFilter;

      final searchMatch =
          query.isEmpty || item.searchText.toLowerCase().contains(query);

      return categoryMatch && searchMatch;
    }).toList();
  }
}
