import 'package:flutter/material.dart';

class CalculatorProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool _showCalculator = false;
  bool get showCalculator => _showCalculator;

  // ── SHOW / HIDE CALCULATOR ─────────────────────
  void showKeyboard() {
    _showCalculator = true;
    notifyListeners();
  }

  void hideKeyboard() {
    _showCalculator = false;
    notifyListeners();
  }

  // ── INPUT HANDLING ─────────────────────────────
  void addValue(String value) {
    controller.text += value;
    notifyListeners();
  }

  void deleteLast() {
    if (controller.text.isNotEmpty) {
      controller.text =
          controller.text.substring(0, controller.text.length - 1);
      notifyListeners();
    }
  }

  // ── DELETE WORD (your logic moved here) ────────
  void deleteWord() {
    String text = controller.text.trimRight();
    int lastSpace = text.lastIndexOf(' ');

    if (lastSpace == -1) {
      controller.text = '';
    } else {
      controller.text = text.substring(0, lastSpace);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}