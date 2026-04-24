import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  bool notificationsEnabled = true;

  String name = "Mohammad Danyal Khan";
  String role = "Flutter Developer";

  void toggleNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  void logout() {
    // later: Firebase logout logic
    debugPrint("User logged out");
  }

  void deleteAccount() {
    // later: Firebase delete logic
    debugPrint("Account deleted");
  }
}