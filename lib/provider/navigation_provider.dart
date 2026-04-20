import 'dart:io';
import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  File? _capturedImage;

  int get selectedIndex => _selectedIndex;
  File? get capturedImage => _capturedImage;

  void changeIndex(int index) {
    if (index != 2) {
      clearImage(); // 🔥 auto clear when leaving solver
    }
    _selectedIndex = index;
    notifyListeners();
  }

  void setImageAndNavigate(File image, int index) {
    _capturedImage = image;
    _selectedIndex = index;
    notifyListeners();
  }

  void clearImage() {
    _capturedImage = null;
    notifyListeners();
  }
}
