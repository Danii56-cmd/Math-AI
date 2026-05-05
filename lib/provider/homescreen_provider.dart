import 'package:flutter/material.dart';
import 'package:math_ai/provider/course_provider.dart';

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
  final List<RecentActivityItem> _recentActivity = [];
  List<RecentActivityItem> get recentActivity =>
      List.unmodifiable(_recentActivity);

  void recordCourseView(CourseModel course) {
    // Remove duplicate if already exists
    _recentActivity.removeWhere((item) => item.title == course.title);

    _recentActivity.insert(
      0,
      RecentActivityItem(
        icon: course.icon,
        title: course.title,
        category: course.category,
        time: DateTime.now(),
      ),
    );

    // Keep only the last 10
    if (_recentActivity.length > 10) _recentActivity.removeLast();

    notifyListeners();
  }
}
