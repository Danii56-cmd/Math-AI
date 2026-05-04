import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:math_ai/controllers/math_controller.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/models/hive_model.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/shared_widgets/custom_pop_scope.dart';
import 'package:math_ai/view/history/database_helper.dart';
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
  String _interpretedProblem = "";
  List<dynamic> _steps = [];
  String _finalAnswer = "";

  @override
  void initState() {
    super.initState();
    _solve();
  }

  Future<void> _solve() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final navProvider = Provider.of<NavigationProvider>(
        context,
        listen: false,
      );
      final imageFile = navProvider.capturedImage;

      Map<String, dynamic> result;

      if (imageFile != null) {
        // Image available — send directly to Gemini Vision
        result = await MathController.solveFromImage(imageFile);
      } else if (navProvider.expression != null &&
          navProvider.expression!.isNotEmpty) {
        // Text expression — send as text
        result = await MathController.solveFromText(navProvider.expression!);
      } else {
        setState(() {
          // _errorMessage = "No image or expression provided.";
          _isLoading = false;
        });
        return;
      }

      if (!mounted) return;

      final interpreted = result['interpreted_problem']?.toString() ?? "";
      final solution =
          result['final_answer']?.toString() ?? "No answer returned";

      // 🔥 SAVE TO FIRESTORE HERE
      await DatabaseHelper.saveHistory(
        HistoryModel(
          question: interpreted,
          solution: solution,
          category: _detectCategory(interpreted),
          type: imageFile != null ? "image" : "text",
          steps: result['steps'] ?? [],
          searchText: interpreted.toLowerCase(),
          createdAt: DateTime.now(),
        ),
      );

      setState(() {
        _interpretedProblem = interpreted;
        _steps = result['steps'] as List<dynamic>? ?? [];
        _finalAnswer = solution;
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

  String _detectCategory(String text) {
    final t = text.toLowerCase();

    if (t.contains("∫") || t.contains("dx")) {
      return "Calculus";
    } else if (t.contains("x") || t.contains("^")) {
      return "Algebra";
    } else if (t.contains("triangle") || t.contains("angle")) {
      return "Geometry";
    } else {
      return "General";
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final navProvider = Provider.of<NavigationProvider>(context);
    final imageFile = navProvider.capturedImage;

    return CustomPopScope(
      child: Scaffold(
        backgroundColor: c.bg,
        appBar: AppBar(
          backgroundColor: c.surface,
          shadowColor: c.border,
          elevation: 0.7,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: c.iconColor),
            onPressed: () {
              final nav = Provider.of<NavigationProvider>(
                context,
                listen: false,
              );
              // nav.changeIndex(0);
              nav.clearImage();
              nav.setExpressionAndNavigate("", 0, image: null);
              // Navigator.pop(context);
              nav.changeIndex(0);
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
            if (_errorMessage.isNotEmpty)
              IconButton(
                icon: Icon(Icons.refresh, color: c.iconColor),
                onPressed: _solve,
              ),
            IconButton(
              icon: Icon(Icons.share_rounded, color: c.iconColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: c.iconColor),
              onPressed: () {},
            ),
          ],
        ),

        body: _isLoading
            // ── Loading ──────────────────────────────────────────────
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
            // ── Error ─────────────────────────────────────────────────
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
                        onPressed: _solve,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Try Again"),
                      ),
                    ],
                  ),
                ),
              )
            // ── Result ────────────────────────────────────────────────
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Captured Image ──────────────────────────────
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
                                child: const Text("No Image — tap to pick one"),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.file(imageFile, fit: BoxFit.cover),
                            ),
                    ),

                    // ── Interpreted Problem ─────────────────────────
                    if (_interpretedProblem.isNotEmpty) ...[
                      Text(
                        "Interpreted Problem",
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
                            colors: [
                              c.primary.withValues(alpha: 0.1),
                              c.surface,
                            ],
                            stops: const [0.0, 0.025],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _interpretedProblem,
                          style: TextStyle(color: c.title, fontSize: 16.sp),
                        ),
                      ),
                    ],

                    // ── Steps Header ─────────────────────────────────
                    Column(
                      children: [
                        SizedBox(height: 10.h),
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
                                "AI Solver",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: c.subtitle,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ), // ── Steps List ───────────────────────────────────
                        if (_steps.isEmpty)
                          Center(
                            child: Text(
                              "No steps returned, please give me a Math Problem or Image.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: c.subtitle,
                                fontSize: 13.sp,
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _steps.length,
                            itemBuilder: (context, index) {
                              final step = _steps[index];
                              if (step is! Map) return const SizedBox.shrink();
                              final stepMap = Map<String, dynamic>.from(step);
                              return SolverScreenStepsContainer(
                                stepNumber: index,
                                title: (stepMap['title'] as String?) ?? "",
                                description:
                                    (stepMap['description'] as String?) ?? "",
                                formula: (stepMap['formula'] as String?) ?? "",
                              );
                            },
                          ),
                        SizedBox(height: 20.h),

                        // ── Final Answer ─────────────────────────────────
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 20.h,
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 24.h,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(60, 104, 171, 255),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
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
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              // Removed broken Expanded inside Column
                              Text(
                                _finalAnswer,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: c.primary,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // ── Action Buttons ───────────────────────────────
                    SolverAIContainer(
                      color: c.surface,
                      text: "Explain More",
                      icon: Icons.auto_awesome_outlined,
                      textColor: c.primary,
                      iconColor: c.primary,
                      onTap: () {
                        Navigator.pushNamed(context, "/aichatbot_screen");
                      },
                    ),
                    SizedBox(height: 10.h),
                    SolverAIContainer(
                      color: c.primary,
                      text: "Ask AI Chat",
                      icon: Icons.smart_toy_outlined,
                      textColor: c.surface,
                      iconColor: c.surface,
                      onTap: () {
                        Navigator.pushNamed(context, "/aichatbot_screen");
                      },
                    ),
                    SizedBox(height: 10.h),
                    SolverAIContainer(
                      color: c.surface,
                      text: "Similar Task",
                      icon: Icons.history,
                      textColor: c.primary,
                      iconColor: c.primary,
                      onTap: () {
                        // ── FIX: pass fromBottomNav: false so back button pops back here ──
                        Provider.of<NavigationProvider>(
                          context,
                          listen: false,
                        ).changeIndex(1);
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
      ),
    );
  }
}

// ── Steps Card ────────────────────────────────────────────────────────────────

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
                color: c.subtitle.withValues(alpha: 0.1),
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
                            color: c.primary.withValues(alpha: 0.3),
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

// ── Action Button ─────────────────────────────────────────────────────────────

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
