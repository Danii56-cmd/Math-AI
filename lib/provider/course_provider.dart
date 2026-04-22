import 'package:flutter/material.dart';

class CourseProvider extends ChangeNotifier {
  // 🔍 SEARCH
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  void updateSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  // 🧩 FILTER
  String _selectedFilter = "All Topics";
  String get selectedFilter => _selectedFilter;

  void changeFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // 📚 TOPICS
  final List<String> _topics = [
    "Completing the square",
    "Parabola Graphing",
    "Factoring Polynomials",
  ];

  List<String> get topics => _topics;

  // 💾 SAVED ITEMS
  final Set<String> _savedTopics = {};

  Set<String> get savedTopics => _savedTopics;

  void toggleSave(String topic) {
    if (_savedTopics.contains(topic)) {
      _savedTopics.remove(topic);
    } else {
      _savedTopics.add(topic);
    }
    notifyListeners();
  }

  bool isSaved(String topic) {
    return _savedTopics.contains(topic);
  }

  // 🔎 FILTERED TOPICS (SEARCH + FILTER COMBINED)
  List<String> get filteredTopics {
    return _topics.where((topic) {
      final matchesSearch = topic.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final matchesFilter =
          _selectedFilter == "All Topics" || topic.contains(_selectedFilter);

      return matchesSearch && matchesFilter;
    }).toList();
  }
}
