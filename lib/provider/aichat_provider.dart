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

    // Show how Gemini interpreted the problem
    final interpreted = result['interpreted_problem']?.toString();
    if (interpreted != null && interpreted.isNotEmpty) {
      _messages.add(
        ChatMessage.text(text: "I see: $interpreted", role: MessageRole.ai),
      );
    }

    // Show each step
    final steps = result['steps'] as List<dynamic>?;
    if (steps != null && steps.isNotEmpty) {
      for (int i = 0; i < steps.length; i++) {
        final step = steps[i] as Map<String, dynamic>;
        _messages.add(
          ChatMessage.steps(
            stepNumber: (i + 1).toString().padLeft(2, '0'),
            stepTitle: step['title']?.toString() ?? "Step ${i + 1}",
            stepDescription: step['description']?.toString() ?? "",
            formula: step['formula']?.toString() ?? "",
          ),
        );
      }
    }

    // Show final answer
    final finalAnswer = result['final_answer']?.toString();
    if (finalAnswer != null && finalAnswer.isNotEmpty) {
      _messages.add(ChatMessage.finalResult(formula: finalAnswer));
    }

    notifyListeners();
    _scrollToBottom();
  }

  void _handleError(Object e) {
    _isTyping = false;
    _messages.add(
      ChatMessage.text(
        text: "Could not solve the problem. Please try again.\n$e",
        role: MessageRole.ai,
      ),
    );
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
