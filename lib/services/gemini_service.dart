import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = "AIzaSyDGbomYk0kqrZvKpOME-GxBIByCRNh5KPM";
  static const String _url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

  // ── System instruction: math only ─────────────────────────────────────────
  static const Map<String, dynamic> _systemInstruction = {
    "parts": [
      {
        "text": """
You are Math Mentor, a math-only AI tutor built into a math solving app.

STRICT RULES:
- You ONLY answer math-related questions: arithmetic, algebra, geometry, calculus, trigonometry, statistics, etc.
- If the user asks ANYTHING that is not math (e.g. coding, history, general chat, jokes, weather, etc.), you must refuse.
- When refusing, still return valid JSON with final_answer set to the refusal message.

REFUSAL FORMAT (use this for non-math input):
{
  "interpreted_problem": "non-math",
  "steps": [],
  "final_answer": "I can only solve math problems. Please enter a math question."
}

MATH RESPONSE FORMAT:
{
  "interpreted_problem": "problem in plain English",
  "steps": [{"title": "...", "description": "...", "formula": "..."}],
  "final_answer": "final result"
}

Return ONLY valid JSON. No markdown, no backticks, no extra text.
""",
      },
    ],
  };

  static Future<Map<String, dynamic>> solveFromImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final ext = imageFile.path.split('.').last.toLowerCase();
    final mime = ext == 'png' ? 'image/png' : 'image/jpeg';

    return _post({
      "system_instruction": _systemInstruction,
      "contents": [
        {
          "parts": [
            {
              "inline_data": {"mime_type": mime, "data": base64Encode(bytes)},
            },
            {
              "text":
                  "Solve the math problem shown in this image step by step.",
            },
          ],
        },
      ],
      "generationConfig": {
        "temperature": 0.1,
        "responseMimeType": "application/json",
      },
    });
  }

  static Future<Map<String, dynamic>> solveFromText(String expression) async {
    return _post({
      "system_instruction": _systemInstruction,
      "contents": [
        {
          "parts": [
            {"text": expression},
          ],
        },
      ],
      "generationConfig": {
        "temperature": 0.1,
        "responseMimeType": "application/json",
      },
    });
  }

  static Future<Map<String, dynamic>> _post(Map<String, dynamic> body) async {
    final response = await http
        .post(
          Uri.parse("$_url?key=$_apiKey"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) return _parse(response.body);

    // Extract real error message from API response
    try {
      final err = jsonDecode(response.body);
      final msg = err['error']?['message']?.toString() ?? response.body;
      throw Exception('${response.statusCode}: $msg');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('${response.statusCode}: ${response.body}');
    }
  }

  static Map<String, dynamic> _parse(String body) {
    final data = jsonDecode(body);
    final raw = data['candidates'][0]['content']['parts'][0]['text'] as String;
    final cleaned = raw
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    try {
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (_) {
      final match = RegExp(r'\{[\s\S]+\}').firstMatch(cleaned);
      if (match != null)
        return jsonDecode(match.group(0)!) as Map<String, dynamic>;
      throw Exception('Could not parse response: $cleaned');
    }
  }
}
