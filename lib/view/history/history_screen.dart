import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.bg,
        elevation: 0.7,
        shadowColor: c.subtitle.withOpacity(0.1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: c.title),
          onPressed: () {
            final navProvider = Provider.of<NavigationProvider>(
              context,
              listen: false,
            );
            navProvider.changeIndex(0);
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
            icon: Icon(Icons.share_rounded, color: c.title),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: c.title),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                _buildSearchBar(context, c),
                SizedBox(height: 20.h),
                _buildFilterChips(context, c),
                SizedBox(height: 30.h),
                _sectionHeader("TODAY", context, c),
                HistoryItemCard(
                  time: "14:22 PM",
                  tag: "ALGEBRA",
                  problem: "3x² + 12x - 9 = 0",
                  solution: "x = -2 ± √7",
                  isFinal: true,
                ),
                HistoryItemCard(
                  time: "09:15 AM",
                  tag: "CALCULUS",
                  problem: "∫ (sin x + cos x) dx",
                  solution: "sin x - cos x + C",
                  isFinal: true,
                ),
                _sectionHeader("YESTERDAY", context, c),
                HistoryItemCard(
                  time: "16:45 PM",
                  tag: "GEOMETRY",
                  problem: "Area of Triangle ABC",
                  solution: "42.5 cm²",
                  isFinal: false,
                ),
                HistoryItemCard(
                  time: "11:20 AM",
                  tag: "ALGEBRA",
                  problem: "log₂(x + 1) = 3",
                  solution: "x = 7",
                  isFinal: false,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _buildSearchBar(BuildContext context, AppColors c) {
    return TextField(
      style: TextStyle(color: c.title),
      decoration: InputDecoration(
        filled: true,
        fillColor: c.card,
        prefixIcon: Icon(Icons.search, color: c.subtitle),
        hintText: "Search past solutions...",
        hintStyle: TextStyle(color: c.subtitle),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: c.primary.withOpacity(0.3)),
        ),
      ),
    );
  }

  // ================= FILTER CHIPS =================
  Widget _buildFilterChips(BuildContext context, AppColors c) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip(c, "All History", isSelected: true),
          _filterChip(c, "Algebra"),
          _filterChip(c, "Calculus"),
          _filterChip(c, "Geometry"),
          _filterChip(c, "Trigonometry"),
          _filterChip(c, "Statistics"),
        ],
      ),
    );
  }

  Widget _filterChip(AppColors c, String label, {bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: isSelected ? c.primary : c.card,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: isSelected ? Colors.transparent : c.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : c.subtitle,
          fontWeight: FontWeight.bold,
          fontSize: 13.sp,
        ),
      ),
    );
  }

  // ================= SECTION HEADER =================
  Widget _sectionHeader(String title, BuildContext context, AppColors c) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, bottom: 10.h, top: 10.h),
      child: Text(
        title,
        style: TextStyle(
          color: c.subtitle,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ================= HISTORY ITEM CARD =================
class HistoryItemCard extends StatelessWidget {
  final String time, tag, problem, solution;
  final bool isFinal;

  const HistoryItemCard({
    super.key,
    required this.time,
    required this.tag,
    required this.problem,
    required this.solution,
    required this.isFinal,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: c.card, // white in light, #1E293B in dark
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: c.isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── TIME left + TAG + 3dot right ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(color: c.subtitle, fontSize: 11.sp),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TAG chip — outlined grey in light, cyan-tinted in dark
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: c.isDark
                            ? c.primary.withOpacity(0.4)
                            : Colors.grey.withOpacity(0.35),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: c.isDark ? c.primary : c.subtitle,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.more_vert, color: c.subtitle, size: 18.sp),
                ],
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // ── PROBLEM ────────────────────────────────────────────────────
          Text(
            problem,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: c.title,
            ),
          ),

          SizedBox(height: 16.h),

          // ── SOLUTION BOX ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              // light: #EEF2FF for isFinal, same for !isFinal
              // dark:  slightly raised surface
              color: c.surfaceVariant,
              borderRadius: BorderRadius.circular(12.r),
              border: !isFinal
                  ? Border(
                      left: BorderSide(color: c.primary, width: 4.w),
                    )
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isFinal)
                  CircleAvatar(
                    backgroundColor: c.primary,
                    radius: 18.r,
                    child: Icon(Icons.check, color: Colors.white, size: 16.sp),
                  ),
                if (isFinal) SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFinal ? "FINAL SOLUTION" : "RESULT",
                      style: TextStyle(
                        color: c.primary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      solution,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: c.title,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
