import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/services/gemini_service.dart';
import 'package:provider/provider.dart';

class SolverScreen extends StatefulWidget {
  final String expression;
  const SolverScreen({Key? key, required this.expression}) : super(key: key);

  @override
  State<SolverScreen> createState() => _SolverScreenState();
}

class _SolverScreenState extends State<SolverScreen> {
  bool _isLoading = true;
  String _errorMessage = "";
  List<dynamic> _steps = [];
  String _finalAnswer = "";

  @override
  void initState() {
    super.initState();
    _callGemini(); // 🔥 auto call when screen opens
  }

  Future<void> _callGemini() async {
    try {
      final result = await GeminiService.solveMath(widget.expression);

      if (!mounted) return;

      setState(() {
        _steps = result['steps'] ?? [];
        _finalAnswer = result['final_answer'] ?? "No answer returned";
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = "Failed to solve: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final navProvider = Provider.of<NavigationProvider>(context);
    final imageFile = navProvider.capturedImage;

    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.surface,
        shadowColor: c.border,
        elevation: 0.7,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: c.iconColor),
          onPressed: () {
            final nav = Provider.of<NavigationProvider>(context, listen: false);
            nav.changeIndex(0);
            nav.clearImage();
          },
        ),
        title: Text(
          "Math AI",
          style: TextStyle(
            color: c.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Retry button in case of error
          if (_errorMessage.isNotEmpty)
            IconButton(
              icon: Icon(Icons.refresh, color: c.iconColor),
              onPressed: _callGemini,
            ),
          IconButton(
            icon: Icon(Icons.share_rounded, color: c.iconColor),
            onPressed: () {},
          ),
        ],
      ),

      body: _isLoading
          // ── Loading State ──
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCircle(color: c.primary),
                  SizedBox(height: 20.h),
                  Text(
                    "Solving your problem...",
                    style: TextStyle(color: c.subtitle, fontSize: 14.sp),
                  ),
                ],
              ),
            )
          // ── Error State ──
          : _errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                    SizedBox(height: 16.h),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: c.subtitle, fontSize: 13.sp),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: _callGemini,
                      icon: Icon(Icons.refresh),
                      label: Text("Try Again"),
                    ),
                  ],
                ),
              ),
            )
          // ── Result State ──
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Captured Image
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.h),
                    height: 180.h,
                    width: double.infinity,
                    child: imageFile == null
                        ? Center(
                            child: TextButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                "/camera_screen",
                              ),
                              child: Text("No Image — tap to pick one"),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.file(imageFile, fit: BoxFit.cover),
                          ),
                  ),

                  // Extracted Problem
                  Text(
                    "Captured Problem",
                    style: TextStyle(color: c.primary, fontSize: 14.sp),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [c.primary.withOpacity(0.1), c.surface],
                        stops: const [0.0, 0.025],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      widget.expression.isEmpty
                          ? "No expression"
                          : widget.expression,
                      style: TextStyle(color: c.title, fontSize: 16.sp),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Steps Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Step-by-Step\nBreakdown",
                        style: TextStyle(
                          color: c.title,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 42,
                        width: 90,
                        decoration: BoxDecoration(
                          color: c.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Gemini\nFlash",
                          style: TextStyle(
                            color: c.subtitle,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Dynamic Steps from Gemini
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _steps.length,
                    itemBuilder: (context, index) {
                      final step = _steps[index];
                      return SolverScreenStepsContainer(
                        stepNumber: index,
                        title: step['title'] ?? "",
                        description: step['description'] ?? "",
                        formula: step['formula'] ?? "",
                      );
                    },
                  ),

                  // Final Answer Box
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 20.h,
                    ),
                    height: 130.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(60, 104, 171, 255),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 25.r,
                          width: 110.r,
                          decoration: BoxDecoration(
                            color: c.primary,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "FINAL ANSWER",
                            style: TextStyle(
                              color: c.surface,
                              fontSize: 08.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            _finalAnswer,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: c.primary,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  SolverAIContainer(
                    color: c.surface,
                    text: "Explain More",
                    icon: Icons.auto_awesome_outlined,
                    textColor: c.primary,
                    iconColor: c.primary,
                    onTap: () {},
                  ),
                  SizedBox(height: 10.h),
                  SolverAIContainer(
                    color: c.primary,
                    text: "Ask AI Chat",
                    icon: Icons.smart_toy_outlined,
                    textColor: c.surface,
                    iconColor: c.surface,
                    onTap: () =>
                        Navigator.pushNamed(context, "/aichatbot_screen"),
                  ),
                  SizedBox(height: 10.h),
                  SolverAIContainer(
                    color: c.surface,
                    text: "Similar Task",
                    icon: Icons.history,
                    textColor: c.primary,
                    iconColor: c.primary,
                    onTap: () {},
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
    );
  }
}

// ── Steps Card ──────────────────────────────────────────────

class SolverScreenStepsContainer extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final String formula;

  const SolverScreenStepsContainer({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.formula,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        children: [
          // Watermark number
          Positioned(
            top: 10.h,
            right: 20.w,
            child: Text(
              (stepNumber + 1).toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
                color: c.subtitle.withOpacity(0.1),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step number badge
                    Container(
                      height: 40.r,
                      width: 40.r,
                      decoration: BoxDecoration(
                        color: c.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: c.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        (stepNumber + 1).toString(),
                        style: TextStyle(
                          color: c.surface,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    // Title
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: c.title,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15.h),

                // Description
                Padding(
                  padding: EdgeInsets.only(left: 55.w),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: c.subtitle,
                      height: 1.5,
                    ),
                  ),
                ),

                // Formula (only show if not empty)
                if (formula.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Container(
                    margin: EdgeInsets.only(left: 55.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: c.bg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      formula,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Courier',
                        color: c.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────

class SolverAIContainer extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;

  const SolverAIContainer({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        alignment: Alignment.center,
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 20.sp),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
