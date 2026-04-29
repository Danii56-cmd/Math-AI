import 'dart:io';
import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  File? _capturedImage;
  String? _expression;

  int get selectedIndex => _selectedIndex;
  File? get capturedImage => _capturedImage;
  String? get expression => _expression;

  void changeIndex(int index) {
    if (index != 2) {
      clearImage(); // 🔥 auto clear when leaving solver
      _expression = null;
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

  // ✅ Add this method to NavigationProvider
  void setExpressionAndNavigate(
    String expression,
    int pageIndex, {
    File? image,
    String? rawOcrText, // 👈 add this
  }) {
    _expression = expression;
    _rawOcrText = rawOcrText; // 👈 store it
    _capturedImage = image;
    _selectedIndex = pageIndex;
    notifyListeners();
  }
  

  // Add field:
  String? _rawOcrText;
  String? get rawOcrText => _rawOcrText;
}
