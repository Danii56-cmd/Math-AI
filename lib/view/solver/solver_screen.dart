import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class SolverScreen extends StatelessWidget {
  const SolverScreen({super.key});

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
            final navProvider = Provider.of<NavigationProvider>(
              context,
              listen: false,
            );
            navProvider.changeIndex(0); // 👈 go back to Home
            navProvider.clearImage(); // clear image when goes back
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
            icon: Icon(Icons.share_rounded, color: c.iconColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: c.iconColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 05.w, vertical: 20.h),
                height: 180.h,
                width: double.infinity,
                // decoration: BoxDecoration(
                //   // color: AppConstants.secondaryColor,
                //   // borderRadius: BorderRadius.circular(20.r),
                // ),
                child: imageFile == null
                    ? Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/camera_screen");
                          },
                          child: Text("No Image, Click to Pick an Image"),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.file(imageFile, fit: BoxFit.cover),
                      ),
              ),
              imageFile == null
                  ? SizedBox.shrink()
                  : Column(
                      children: [
                        Text(
                          "Captured Problem",
                          style: TextStyle(color: c.primary, fontSize: 14.sp),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 05.w,
                            vertical: 20.h,
                          ),
                          // alignment: Alignment.center,
                          height: 70.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                c.primary.withValues(alpha: 0.1),
                                c.surface,
                              ],
                              stops: const [0.0, 0.025], // 👈 key magic
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: c.border.withOpacity(0.08),
                                blurRadius: 2,
                                spreadRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 40.w, top: 20.h),
                            child: Text(
                              "∫ (3x² + 2x + 1) dx",
                              style: TextStyle(color: c.title, fontSize: 16.sp),
                            ),
                          ),
                        ),
                        Text(
                          "Evaluate the indefinite integral with respect to x.",
                          style: TextStyle(color: c.subtitle, fontSize: 12.sp),
                        ),
                        SizedBox(height: 20),
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
                            Padding(
                              padding: EdgeInsets.only(right: 05.w),
                              child: Container(
                                alignment: Alignment.center,
                                height: 42,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: c.surfaceVariant,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Calculus AI\nv2.4",
                                  style: TextStyle(
                                    color: c.subtitle,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return SolverScreenStepsContainer(
                              steps: index.toString(),
                            );
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 20.h,
                          ),
                          // alignment: Alignment.center,
                          height: 130.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              // Outer shadow
                              BoxShadow(
                                color: Color.fromARGB(60, 104, 171, 255),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                              // Left blue glow
                              BoxShadow(
                                color: Color.fromARGB(60, 104, 171, 255),
                                blurRadius: 0.1,
                                spreadRadius: 0.1,
                                offset: const Offset(-4, 0),
                              ),
                              // Right blue glow
                              BoxShadow(
                                color: Color.fromARGB(60, 104, 171, 255),
                                blurRadius: 0.1,
                                spreadRadius: 0.1,
                                offset: const Offset(5, 0),
                              ),
                              // Top blue glow
                              BoxShadow(
                                color: Color.fromARGB(60, 104, 171, 255),
                                blurRadius: 0.1,
                                spreadRadius: 0.1,
                                offset: const Offset(0, -4),
                              ),
                              // Bottom blue glow
                              BoxShadow(
                                color: Color.fromARGB(60, 104, 171, 255),
                                blurRadius: 0.1,
                                spreadRadius: 0.1,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 25.r,
                                width: 100.r,
                                decoration: BoxDecoration(
                                  color: c.primary,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "FINAL RESULTS",
                                  style: TextStyle(
                                    color: c.surface,
                                    fontSize: 08.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "x³ + x² + x + C",
                                style: TextStyle(
                                  color: c.primary,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

              Column(
                children: [
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
                    onTap: () {
                      Navigator.pushNamed(context, "/aichatbot_screen");
                    },
                  ),

                  SizedBox(height: 10.h),
                  SolverAIContainer(
                    onTap: () {},
                    color: c.surface,
                    text: "Similar Task",
                    icon: Icons.history,
                    textColor: c.primary,
                    iconColor: c.primary,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SolverAIContainer extends StatelessWidget {
  final text;
  final icon;
  final color;
  final textColor;
  final iconColor;
  final VoidCallback onTap;
  SolverAIContainer({
    super.key,
    this.text,
    this.icon,
    this.color,
    this.textColor,
    this.iconColor,
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

class SolverScreenStepsContainer extends StatelessWidget {
  final String steps;
  const SolverScreenStepsContainer({super.key, required this.steps});

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
          // 1. "01" Watermark (Background Layer)
          Positioned(
            top: 10.h,
            right: 20.w,
            child: Text(
              (int.parse(steps) + 1).toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
                color: c.subtitle.withOpacity(0.1),
              ),
            ),
          ),

          // 2. Main Content Layer
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Number Badge with Shadow
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
                        (int.parse(steps) + 1).toString(),
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
                          "Apply Sum Rule",
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
                // Description Text
                Padding(
                  padding: EdgeInsets.only(left: 55.w), // Aligns with the title
                  child: Text(
                    "The integral of a sum is the sum of the integrals. We can separate the polynomial into individual terms.",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: c.subtitle,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Math Formula Container
                Container(
                  margin: EdgeInsets.only(left: 65.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 07.w,
                    vertical: 15.h,
                  ),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    "∫ 3x² dx + ∫ 2x dx +\n∫ 1 dx",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Courier', // Or a math-specific font
                      color: c.title,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
