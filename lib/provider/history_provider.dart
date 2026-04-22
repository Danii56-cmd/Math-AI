import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> _history = [
    {
      "time": "14:22 PM",
      "tag": "ALGEBRA",
      "problem": "3x² + 12x - 9 = 0",
      "solution": "x = -2 ± √7",
      "isFinal": true,
      "date": "today",
    },
    {
      "time": "09:15 AM",
      "tag": "CALCULUS",
      "problem": "∫ (sin x + cos x) dx",
      "solution": "sin x - cos x + C",
      "isFinal": true,
      "date": "today",
    },
    {
      "time": "16:45 PM",
      "tag": "GEOMETRY",
      "problem": "Area of Triangle ABC",
      "solution": "42.5 cm²",
      "isFinal": false,
      "date": "yesterday",
    },
  ];

  List<Map<String, dynamic>> get history => _history;

  // 🔥 FILTERED (SEARCH + CATEGORY)
  List<Map<String, dynamic>> get filteredHistory {
    return _history.where((item) {
      final matchSearch = item["problem"].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final matchFilter = _selectedFilter == "All History"
          ? true
          : item["date"] == _selectedFilter.toLowerCase();

      return matchSearch && matchFilter;
    }).toList();
  }

  // 🔥 GROUPED LOGIC (BASED ON FILTER)
  bool get showTodayOnly => _selectedFilter == "Today";
  bool get showYesterdayOnly => _selectedFilter == "Yesterday";

  List<Map<String, dynamic>> get todayItems =>
      filteredHistory.where((e) => e["date"] == "today").toList();

  List<Map<String, dynamic>> get yesterdayItems =>
      filteredHistory.where((e) => e["date"] == "yesterday").toList();
}
