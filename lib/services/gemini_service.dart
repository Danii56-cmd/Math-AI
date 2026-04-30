import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = "AIzaSyAIqmJjEzRLnUhz0taaje0OK0sxHLrFXsY";
  static const String _url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

  /// Send image directly to Gemini Vision — no OCR, no cleaning needed
  static Future<Map<String, dynamic>> solveFromImage(File imageFile) async {
    return await _retryRequest(() => _callVisionApi(imageFile));
  }

  /// Solve from plain text expression (typed by user)
  static Future<Map<String, dynamic>> solveFromText(String expression) async {
    return await _retryRequest(() => _callTextApi(expression));
  }

  static Future<T> _retryRequest<T>(Future<T> Function() request) async {
    int attempt = 0;
    const maxAttempts = 4;

    while (true) {
      try {
        return await request();
      } catch (e) {
        attempt++;
        final is503 =
            e.toString().contains('503') ||
            e.toString().contains('UNAVAILABLE');
        final is429 =
            e.toString().contains('429') ||
            e.toString().contains('RESOURCE_EXHAUSTED');

        if ((is503 || is429) && attempt < maxAttempts) {
          final waitSeconds = pow(2, attempt).toInt();
          await Future.delayed(Duration(seconds: waitSeconds));
          continue;
        }
        rethrow;
      }
    }
  }

  static Future<Map<String, dynamic>> _callVisionApi(File imageFile) async {
    // Read image as base64
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    // Detect mime type
    final ext = imageFile.path.split('.').last.toLowerCase();
    final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

    const prompt = """
You are a math tutor. Look at the math problem in this image carefully.

IMPORTANT:
- Read ALL symbols exactly as shown: fractions, division bars, square roots, powers, etc.
- A horizontal bar between two numbers or expressions means DIVISION (fraction)
- Do NOT merge separate numbers — if you see 3 over 4, that is 3 divided by 4, not 34
- Solve the problem step by step

Return ONLY a valid JSON object with no markdown, no backticks, no extra text:

{
  "interpreted_problem": "Write the problem exactly as you see it, e.g. 3/4 + 1/2",
  "steps": [
    {
      "title": "Step title",
      "description": "Plain English explanation",
      "formula": "The math at this step"
    }
  ],
  "final_answer": "The final simplified result"
}
""";

    for (int i = 0; i < 3; i++) {
      final response = await http
          .post(
            Uri.parse("$_url?key=$_apiKey"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "contents": [
                {
                  "parts": [
                    {
                      "inline_data": {
                        "mime_type": mimeType,
                        "data": base64Image,
                      },
                    },
                    {"text": prompt},
                  ],
                },
              ],
              "generationConfig": {
                "temperature": 0.1,
                "responseMimeType": "application/json",
              },
            }),
          )
          .timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      }

      if (response.statusCode == 503) {
        await Future.delayed(Duration(seconds: 2 * (i + 1)));
        continue;
      }

      throw Exception(
        "Gemini API error: ${response.statusCode}\n${response.body}",
      );
    }

    throw Exception("Gemini is busy. Try again later.");
  }

  static Future<Map<String, dynamic>> _callTextApi(String expression) async {
    final prompt =
        """
You are a math tutor. Solve this math problem step by step.

Problem: $expression

Return ONLY a valid JSON object with no markdown, no backticks, no extra text:

{
  "interpreted_problem": "Write the problem in plain English",
  "steps": [
    {
      "title": "Step title",
      "description": "Plain English explanation",
      "formula": "The math at this step"
    }
  ],
  "final_answer": "The final simplified result"
}
""";

    for (int i = 0; i < 3; i++) {
      final response = await http
          .post(
            Uri.parse("$_url?key=$_apiKey"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "contents": [
                {
                  "parts": [
                    {"text": prompt},
                  ],
                },
              ],
              "generationConfig": {
                "temperature": 0.1,
                "responseMimeType": "application/json",
              },
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      }

      if (response.statusCode == 503) {
        await Future.delayed(Duration(seconds: 2 * (i + 1)));
        continue;
      }

      throw Exception(
        "Gemini API error: ${response.statusCode}\n${response.body}",
      );
    }

    throw Exception("Gemini is busy. Try again later.");
  }

  static Map<String, dynamic> _parseResponse(String responseBody) {
    final data = jsonDecode(responseBody);
    final rawText =
        data['candidates'][0]['content']['parts'][0]['text'] as String;

    final cleaned = rawText
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    try {
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (_) {
      final jsonMatch = RegExp(r'\{[\s\S]+\}').firstMatch(cleaned);
      if (jsonMatch != null) {
        return jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      }
      throw Exception("Failed to parse Gemini response:\n$cleaned");
    }
  }
}
