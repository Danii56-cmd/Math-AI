import 'package:flutter/material.dart';

// ======= RECENT ACTIVITY MODEL =======
class RecentActivityItem {
  final IconData icon;
  final String title;
  final String category;
  final DateTime time;

  RecentActivityItem({
    required this.icon,
    required this.title,
    required this.category,
    required this.time,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  String get subtitle => "$timeAgo • $category";
}

// ======= COURSE MODEL =======
class CourseModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final String category;
  final List<String> topics;
  final String youtubePlaylistUrl;

  CourseModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
    required this.topics,
    required this.youtubePlaylistUrl,
  });
}

// ======= COURSE PROVIDER =======
class CourseProvider extends ChangeNotifier {
  // ======= COURSES DATA =======
  final List<CourseModel> _courses = [
    CourseModel(
      title: "Algebra Foundations",
      subtitle: "Variables, equations, and structural foundations.",
      icon: Icons.functions,
      category: "Algebra",
      topics: ["Completing the Square", "Factoring Polynomials", "Logarithms"],
      youtubePlaylistUrl:
          "https://www.youtube.com/playlist?list=PLDesaqWTN6ESsmwELdrzhcGiRhk5DjwLP",
    ),
    CourseModel(
      title: "Calculus",
      subtitle: "Study of change and motion.",
      icon: Icons.change_history,
      category: "Calculus",
      topics: ["Integrals", "Derivatives", "Limits"],
      youtubePlaylistUrl:
          "https://www.youtube.com/playlist?list=PLZHQObOWTQDMsr9K-rj53DwVRMYO3t5Yr",
    ),
    CourseModel(
      title: "Geometry",
      subtitle: "Shapes, dimensions, and space.",
      icon: Icons.category_outlined,
      category: "Geometry",
      topics: ["Triangles", "Circles", "Polygons"],
      youtubePlaylistUrl:
          "https://www.youtube.com/playlist?list=PLP0dNb4-MR2LhzKweiu2Y4b4Urrulo72_",
    ),
    CourseModel(
      title: "Statistics",
      subtitle: "Data analysis and probability.",
      icon: Icons.bar_chart,
      category: "Statistics",
      topics: ["Mean & Median", "Probability", "Distributions"],
      youtubePlaylistUrl:
          "https://www.youtube.com/playlist?list=PL5102DFDC6790F3D0",
    ),
    CourseModel(
      title: "Trigonometry",
      subtitle: "Relationships of triangle sides.",
      icon: Icons.architecture,
      category: "Trigonometry",
      topics: ["Sin/Cos/Tan", "Unit Circle", "Identities"],
      youtubePlaylistUrl:
          "https://www.youtube.com/playlist?list=PLD6DA74C1DBF770E7",
    ),
  ];

  List<CourseModel> get courses => _courses;

  // ======= SEARCH =======
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  void updateSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  // ======= FILTER =======
  String _selectedFilter = "All Topics";
  String get selectedFilter => _selectedFilter;

  void changeFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // ======= FILTERED COURSES =======
  List<CourseModel> get filteredCourses {
    return _courses.where((course) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesFilter =
          _selectedFilter == "All Topics" || course.category == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // ======= FILTERED TOPICS =======
  List<String> get filteredTopics {
    final allTopics = _courses
        .where(
          (c) =>
              _selectedFilter == "All Topics" || c.category == _selectedFilter,
        )
        .expand((c) => c.topics)
        .toList();

    if (_searchQuery.isEmpty) return allTopics;

    return allTopics
        .where((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // ======= SAVED =======
  final Set<String> _savedTopics = {};
  Set<String> get savedTopics => _savedTopics;

  bool isSaved(String topic) => _savedTopics.contains(topic);

  void toggleSave(String topic) {
    _savedTopics.contains(topic)
        ? _savedTopics.remove(topic)
        : _savedTopics.add(topic);
    notifyListeners();
  }

  // ======= RECENT ACTIVITY =======
  final List<RecentActivityItem> _recentActivity = [];

  List<RecentActivityItem> get recentActivity =>
      List.unmodifiable(_recentActivity);

  void recordCourseView(CourseModel course) {
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
    if (_recentActivity.length > 10) _recentActivity.removeLast();
    notifyListeners();
  }
}
