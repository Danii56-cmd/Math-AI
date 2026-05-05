import 'dart:io';
import 'package:flutter/material.dart';
import 'package:math_ai/controllers/math_controller.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────
enum MessageRole { user, ai }

enum MessageContentType { text, steps, finalResult }

// ── ChatMessage model ─────────────────────────────────────────────────────────
class ChatMessage {
  final String text;
  final MessageRole role;
  final MessageContentType contentType;

  final String? stepNumber;
  final String? stepTitle;
  final String? stepDescription;
  final String? formula;

  ChatMessage.text({required this.text, required this.role})
    : contentType = MessageContentType.text,
      stepNumber = null,
      stepTitle = null,
      stepDescription = null,
      formula = null;

  ChatMessage.steps({
    required this.stepNumber,
    required this.stepTitle,
    required this.stepDescription,
    required this.formula,
  }) : text = '',
       role = MessageRole.ai,
       contentType = MessageContentType.steps;

  ChatMessage.finalResult({required this.formula})
    : text = '',
      role = MessageRole.ai,
      contentType = MessageContentType.finalResult,
      stepNumber = null,
      stepTitle = null,
      stepDescription = null;
}

// ── Provider ──────────────────────────────────────────────────────────────────
class AiChatProvider with ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool _isTyping = false;
  bool get isTyping => _isTyping;
  bool get isEmpty => _messages.isEmpty;

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  // ── Called from solution screen when image is passed from camera ────────────
  Future<void> solveFromImage(File imageFile) async {
    // Show user thumbnail message
    _messages.add(
      ChatMessage.text(text: "Solving from image...", role: MessageRole.user),
    );
    _isTyping = true;
    notifyListeners();
    _scrollToBottom();

    try {
      final result = await MathController.solveFromImage(imageFile);
      _handleResult(result);
    } catch (e) {
      _handleError(e);
    }
  }

  // ── Called when user types a message ───────────────────────────────────────
  Future<void> sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty || _isTyping) return;

    _messages.add(ChatMessage.text(text: text, role: MessageRole.user));
    controller.clear();
    _isTyping = true;
    notifyListeners();
    _scrollToBottom();

    try {
      final result = await MathController.solveFromText(text);
      _handleResult(result);
    } catch (e) {
      _handleError(e);
    }
  }

  // ── Shared result handler ──────────────────────────────────────────────────
  void _handleResult(Map<String, dynamic> result) {
    _isTyping = false;

    final interpreted = result['interpreted_problem']?.toString() ?? '';
    final finalAnswer = result['final_answer']?.toString() ?? '';

    // Guard: actual errors
    if (interpreted.toLowerCase().contains('error') ||
        finalAnswer.toLowerCase().startsWith('error') ||
        finalAnswer.isEmpty) {
      _handleError('Something went wrong. Please try again.');
      return;
    }

    // Guard: non-math refusal from Gemini
    if (interpreted.toLowerCase() == 'non-math') {
      _messages.add(
        ChatMessage.text(
          text: "I can only solve math problems. Please enter a math question.",
          role: MessageRole.ai,
        ),
      );
      notifyListeners();
      _scrollToBottom();
      return;
    }

    if (interpreted.isNotEmpty) {
      _messages.add(
        ChatMessage.text(text: "I see: $interpreted", role: MessageRole.ai),
      );
    }

    final steps = result['steps'] as List<dynamic>?;
    if (steps != null) {
      for (int i = 0; i < steps.length; i++) {
        final step = steps[i] as Map<String, dynamic>;
        _messages.add(
          ChatMessage.steps(
            stepNumber: (i + 1).toString(),
            stepTitle: step['title']?.toString() ?? "Step ${i + 1}",
            stepDescription: step['description']?.toString() ?? '',
            formula: step['formula']?.toString() ?? '',
          ),
        );
      }
    }

    _messages.add(ChatMessage.finalResult(formula: finalAnswer));
    notifyListeners();
    _scrollToBottom();
  }

  void _handleError(Object e) {
    _isTyping = false;

    final err = e.toString().replaceFirst('Exception: ', '');

    String message;
    if (err.contains('429')) {
      message = "Quota exceeded — wait a moment and retry.";
    } else if (err.contains('503') || err.contains('UNAVAILABLE')) {
      message = "AI is temporarily busy. Try again shortly.";
    } else if (err.contains('401') || err.contains('API_KEY')) {
      message = "Invalid API key. Check your configuration.";
    } else if (err.contains('SocketException')) {
      message = "No internet connection.";
    } else if (err.contains('TimeoutException')) {
      message = "Request timed out. Try again.";
    } else {
      // Show the real error, but cleaned up
      message = "$err";
    }

    _messages.add(ChatMessage.text(text: message, role: MessageRole.ai));
    notifyListeners();
    _scrollToBottom();
  }

  // ── Utilities ──────────────────────────────────────────────────────────────
  void clearChat() {
    _messages.clear();
    controller.clear();
    _isTyping = false;
    notifyListeners();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
