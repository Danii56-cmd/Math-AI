import 'dart:io';
import 'package:math_ai/services/gemini_service.dart';

class MathController {
  /// Solve directly from image using Gemini Vision
  static Future<Map<String, dynamic>> solveFromImage(File imageFile) async {
    try {
      return await GeminiService.solveFromImage(imageFile);
    } catch (e) {
      return {
        "interpreted_problem": "Error reading image",
        "steps": [],
        "final_answer": "Error: $e",
      };
    }
  }

  /// Solve from typed text
  static Future<Map<String, dynamic>> solveFromText(String expression) async {
    try {
      return await GeminiService.solveFromText(expression);
    } catch (e) {
      return {
        "interpreted_problem": "Error",
        "steps": [],
        "final_answer": "Error: $e",
      };
    }
  }
}
