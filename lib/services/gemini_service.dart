// static const String _apiKey = "AIzaSyCzXM0EtyTDB4Djhja1P8kwye8Hbvsi51g";

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = "AIzaSyCzXM0EtyTDB4Djhja1P8kwye8Hbvsi51g";
  static const String _url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

  static Future<Map<String, dynamic>> solveMath(String problem) async {
    return await _retryRequest(() => _callApi(problem));
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
          // Wait 2s, 4s, 8s between retries
          final waitSeconds = pow(2, attempt).toInt();
          await Future.delayed(Duration(seconds: waitSeconds));
          continue;
        }
        rethrow; // give up after max attempts
      }
    }
  }

  static Future<Map<String, dynamic>> _callApi(String problem) async {
    final response = await http
        .post(
          Uri.parse("$_url?key=$_apiKey"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "contents": [
              {
                "parts": [
                  {
                    "text":
                        """
You are a math tutor. Solve this problem step by step.
Return ONLY a valid JSON object, no markdown, no explanation outside JSON.

Format:
{
  "steps": [
    {
      "title": "Step title here",
      "description": "Explanation here",
      "formula": "Math expression here"
    }
  ],
  "final_answer": "Final answer here"
}

Problem: $problem
""",
                  },
                ],
              },
            ],
          }),
        )
        .timeout(const Duration(seconds: 30)); // ✅ prevent hanging forever

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rawText =
          data['candidates'][0]['content']['parts'][0]['text'] as String;
      final cleaned = rawText
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();
      return jsonDecode(cleaned);
    } else {
      throw Exception(
        "Gemini API error: ${response.statusCode} — ${response.body}",
      );
    }
  }
}
