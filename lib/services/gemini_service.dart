import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = "AIzaSyCsCXvqhKDWFu4ra56yEHOdpIxtPAS-bAo";
  static const String _url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  static Future<Map<String, dynamic>> solveMath(String problem) async {
    final response = await http.post(
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
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rawText =
          data['candidates'][0]['content']['parts'][0]['text'] as String;

      // Strip any accidental markdown fences
      final cleaned = rawText
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();

      return jsonDecode(cleaned);
    } else {
      throw Exception("Gemini API error: ${response.statusCode}");
    }
  }
}
