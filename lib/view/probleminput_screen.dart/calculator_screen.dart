import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/view/probleminput_screen.dart/calculator_widget.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    // final themeProvider = Provider.of<ThemeChangerProvider>(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 249, 251),
      appBar: AppBar(
        backgroundColor: c.card,
        shadowColor: c.subtitle,
        elevation: 0.7,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: c.iconColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Math Ai",
          style: TextStyle(
            color: c.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded, color: c.subtitle),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: c.subtitle),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  "Problem Entry",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: c.primary,
                  ),
                ),
                Text(
                  "What shall we solve\ntoday?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: c.title,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 160.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: c.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(c.isDark ? 0.3 : 0.08),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText:
                                "Enter your equation or\nmathematical problem",
                            hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: c.subtitle,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: c.title,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 30.h,
                            width: 100.w,
                            decoration: BoxDecoration(color: c.card),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline_rounded,
                                  color: c.subtitle,
                                ),
                                Text(
                                  "AI Assistant\nReady",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: c.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(width: 10.w),
                          // Spacer(),
                          Container(
                            height: 30.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: c.primary,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Solve",
                                  style: TextStyle(
                                    color: c.surface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Icon(Icons.auto_awesome, color: c.surface),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 10.h),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // calculator widget
                MathCalculatorWidget(
                  onKeyTap: (value) {
                    _controller.text += value;
                  },
                  onBackspace: () {
                    _controller.text = _controller.text.substring(
                      0,
                      _controller.text.length - 1,
                    );
                  },
                ),
                SizedBox(height: 10.h),
                Divider(
                  color: c.primary,
                  thickness: 3.h,
                  indent: 10.w,
                  endIndent: 250.w,
                ),
                SizedBox(height: 10.h),
                Text(
                  "How to type fractions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: c.title,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Simply use the slash key (/) or the division symbol.\nThe AI will automatically interpret it as a stacked\nfraction for clarity in the solution steps.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: c.subtitle,
                  ),
                ),
                Divider(
                  color: Color.fromARGB(200, 248, 233, 250),
                  thickness: 2.h,
                  indent: 10.w,
                  endIndent: 250.w,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Multiple equations",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: c.title,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Enter a system of equations by placing each\nequation on a new line. Our solver will detect\nvariables and solve for all unknown values\nsimultaneously.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: c.subtitle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
