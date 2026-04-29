import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/provider/aichat_provider.dart';
import 'package:math_ai/shared_widgets/custom_pop_scope.dart';
import 'package:provider/provider.dart';

class AichatbotScreen extends StatelessWidget {
  const AichatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return CustomPopScope(
      child: Scaffold(
        backgroundColor: c.surfaceVariant,
        resizeToAvoidBottomInset: true,

        // ── AppBar ────────────────────────────────────────────────────────────
        appBar: AppBar(
          backgroundColor: c.surface,
          elevation: 0.7,
          shadowColor: c.subtitle,
          leadingWidth: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: c.surfaceVariant,
                backgroundImage: AssetImage(AppConstants.aiBot),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Math Mentor",
                    style: TextStyle(
                      color: c.primary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Typing indicator in the status line
                  Consumer<AiChatProvider>(
                    builder: (context, chat, _) => Row(
                      children: [
                        Container(
                          width: 7.r,
                          height: 7.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: chat.isTyping
                                ? Colors.orange
                                : const Color(0xFF4CAF50),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          chat.isTyping ? "Typing..." : "Online",
                          style: TextStyle(color: c.subtitle, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.history, color: c.subtitle),
              onPressed: () => context.read<AiChatProvider>().clearChat(),
            ),
            IconButton(
              icon: Icon(Icons.more_vert_rounded, color: c.subtitle),
              onPressed: () {},
            ),
            SizedBox(width: 10.w),
          ],
        ),

        // ── Body ──────────────────────────────────────────────────────────────
        body: Column(
          children: [
            // Only this part rebuilds when messages change
            Expanded(
              child: Consumer<AiChatProvider>(
                builder: (context, chat, _) {
                  if (chat.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.smart_toy_outlined,
                            size: 60.r,
                            color: c.subtitle,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "Ask me anything!",
                            style: TextStyle(
                              color: c.subtitle,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: chat.scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    itemCount: chat.messages.length + (chat.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Typing bubble at the very end
                      if (chat.isTyping && index == chat.messages.length) {
                        return const _TypingIndicator();
                      }

                      final msg = chat.messages[index];

                      switch (msg.contentType) {
                        case MessageContentType.steps:
                          return StepsContainer(
                            steps: msg.stepNumber!,
                            title: msg.stepTitle!,
                            description: msg.stepDescription!,
                            formula: msg.formula!,
                          );
                        case MessageContentType.finalResult:
                          return FinalResultCard(formula: msg.formula!);
                        case MessageContentType.text:
                          return _TextBubble(
                            text: msg.text,
                            isUser: msg.role == MessageRole.user,
                          );
                      }
                    },
                  );
                },
              ),
            ),

            // Input bar — no Consumer, uses context.read inside callbacks
            Container(
              color: c.surfaceVariant,
              child: SafeArea(top: false, child: _InputBar()),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  _TextBubble
// ─────────────────────────────────────────────────────────────────────────────
class _TextBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const _TextBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isUser ? c.primary : c.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 20.r : 0),
            topRight: Radius.circular(isUser ? 0 : 20.r),
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? c.title : c.subtitle,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  _TypingIndicator — three animated bouncing dots
// ─────────────────────────────────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                final raw = (_ctrl.value * 3) - i;
                final t = raw.clamp(0.0, 1.0);
                final bounce = t < 0.5 ? t * 2 : (1 - t) * 2;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: 7.r,
                  height: 7.r + (4 * bounce),
                  decoration: BoxDecoration(
                    // withValues fixes the deprecation warning
                    color: c.primary.withValues(alpha: 0.6 + 0.4 * bounce),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  StepsContainer
// ─────────────────────────────────────────────────────────────────────────────
class StepsContainer extends StatelessWidget {
  final String steps;
  final String title;
  final String description;
  final String formula;

  const StepsContainer({
    super.key,
    required this.steps,
    required this.title,
    required this.description,
    required this.formula,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          padding: EdgeInsets.all(24.r),
          width: double.infinity,
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: c.primary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: c.subtitle,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  formula,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: c.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 25.h,
          right: 15.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: c.surfaceVariant,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              "STEP ${steps.padLeft(2, '0')}",
              style: TextStyle(
                color: c.subtitle,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FinalResultCard
// ─────────────────────────────────────────────────────────────────────────────
class FinalResultCard extends StatelessWidget {
  final String formula;
  const FinalResultCard({super.key, required this.formula});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 15.h),
      padding: EdgeInsets.all(30.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.primary, const Color.fromARGB(255, 169, 204, 240)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            // withValues instead of withOpacity — fixes deprecation warning
            color: c.primary.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "FINAL RESULT",
            style: TextStyle(
              color: c.title,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            formula,
            style: TextStyle(
              color: c.title,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            "The derivative represents the slope of the tangent line at any point x on the curve.",
            textAlign: TextAlign.center,
            style: TextStyle(color: c.title, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  _InputBar
// ─────────────────────────────────────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final chat = context.read<AiChatProvider>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: c.iconBg,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt_outlined, color: c.title, size: 22.r),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            SizedBox(width: 4.w),
            IconButton(
              icon: Icon(Icons.image_outlined, color: c.title, size: 22.r),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: TextField(
                controller: chat.controller,
                style: TextStyle(fontSize: 14.sp, color: c.primary),
                onSubmitted: (_) =>
                    context.read<AiChatProvider>().sendMessage(),
                decoration: InputDecoration(
                  hintText: "Ask anything or type an equation...",
                  border: InputBorder.none,
                  isDense: true,
                  hintStyle: TextStyle(fontSize: 14.sp, color: c.title),
                ),
              ),
            ),
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: () => context.read<AiChatProvider>().sendMessage(),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: c.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: c.surface, size: 18.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
