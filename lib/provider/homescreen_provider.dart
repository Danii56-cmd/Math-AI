import 'package:flutter/material.dart';

class RecentActivityItem {
  final String icon;
  final String title;
  final String subtitle;

  RecentActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class HomeProvider extends ChangeNotifier {
  // 🔍 SEARCH
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  void updateSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  // 🗂️ TAB
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void changeTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  // 📋 RECENT ACTIVITY
  final List<RecentActivityItem> _recentActivity = [
    RecentActivityItem(
      icon: "assets/icons/quadratic.png", // replace with AppConstants
      title: "Quadratic Equation",
      subtitle: "Solved 2h ago • Algebra",
    ),
    RecentActivityItem(
      icon: "assets/icons/compass.png", // replace with AppConstants
      title: "Triangle Area",
      subtitle: "Solved 5h ago • Geometry",
    ),
  ];

  List<RecentActivityItem> get recentActivity => _recentActivity;

  // later: add addActivity(), clearHistory(), etc.
}
