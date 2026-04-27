import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────
enum MessageRole { user, ai }

enum MessageContentType { text, steps, finalResult }

// ── ChatMessage model ─────────────────────────────────────────────────────────
class ChatMessage {
  final String text;
  final MessageRole role;
  final MessageContentType contentType;

  // Only used when contentType == steps
  final String? stepNumber;
  final String? stepTitle;
  final String? stepDescription;
  final String? formula;

  // Plain text bubble (user or ai)
  ChatMessage.text({required this.text, required this.role})
    : contentType = MessageContentType.text,
      stepNumber = null,
      stepTitle = null,
      stepDescription = null,
      formula = null;

  // Step card bubble
  ChatMessage.steps({
    required this.stepNumber,
    required this.stepTitle,
    required this.stepDescription,
    required this.formula,
  }) : text = '',
       role = MessageRole.ai,
       contentType = MessageContentType.steps;

  // Final result card
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

  // Pre-populated demo messages — matches your original hardcoded screen
  final List<ChatMessage> _messages = [
    ChatMessage.text(
      text: "Find the derivative of f(x) =\nx³ + 2x",
      role: MessageRole.user,
    ),
    ChatMessage.text(
      text: "Hello! I'd be happy to help...",
      role: MessageRole.ai,
    ),
    ChatMessage.steps(
      stepNumber: "01",
      stepTitle: "The Power Rule",
      stepDescription: "The derivative of xⁿ is n·xⁿ⁻¹.",
      formula: "d/dx [xⁿ] = nxⁿ⁻¹",
    ),
    ChatMessage.steps(
      stepNumber: "02",
      stepTitle: "Apply to each term",
      stepDescription: "We calculate each part separately.",
      formula: "3x² + 2",
    ),
    ChatMessage.finalResult(formula: "f'(x) = 3x² + 2"),
  ];

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  // ── Send user message ───────────────────────────────────────────────────────
  Future<void> sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    // Add user message
    _messages.add(ChatMessage.text(text: text, role: MessageRole.user));
    controller.clear();
    _isTyping = true;
    notifyListeners();
    _scrollToBottom();

    try {
      final result = await GeminiService.solveMath(text);

      _isTyping = false;

      final isMathProblem = result['is_math_problem'] as bool? ?? true;

      if (!isMathProblem) {
        final textReply = result['text_reply']?.toString() ?? "I didn't quite get that.";
        _messages.add(ChatMessage.text(text: textReply, role: MessageRole.ai));
      } else {
        final steps = result['steps'] as List<dynamic>?;
        if (steps != null) {
          for (int i = 0; i < steps.length; i++) {
            final step = steps[i];
            _messages.add(
              ChatMessage.steps(
                stepNumber: "0${i + 1}",
                stepTitle: step['title']?.toString() ?? "Step ${i + 1}",
                stepDescription: step['description']?.toString() ?? "",
                formula: step['formula']?.toString() ?? "",
              ),
            );
          }
        }

        final finalAnswer = result['final_answer']?.toString();
        if (finalAnswer != null && finalAnswer.isNotEmpty) {
          _messages.add(
            ChatMessage.finalResult(formula: finalAnswer),
          );
        }
      }

      notifyListeners();
      _scrollToBottom();
    } catch (e) {
      _isTyping = false;
      _messages.add(
        ChatMessage.text(
          text: "Error: Could not solve the problem. Please try again.",
          role: MessageRole.ai,
        ),
      );
      notifyListeners();
      _scrollToBottom();
    }
  }

  // ── Clear all messages ────────────────────────────────────────────────────
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
