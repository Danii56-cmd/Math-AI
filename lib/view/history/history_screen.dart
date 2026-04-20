import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: AppConstants.otherTextColor,
        elevation: 0.7,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppConstants.secondaryColor,
          ),
          onPressed: () {
            final navProvider = Provider.of<NavigationProvider>(
              context,
              listen: false,
            );
            navProvider.changeIndex(0); // 👈 go back to Home
          },
        ),
        title: Text(
          "Math Ai",
          style: TextStyle(
            color: AppConstants.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded, color: AppConstants.secondaryColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: AppConstants.secondaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                // 1. Search Bar
                _buildSearchBar(),
                SizedBox(height: 20.h),
                // 2. Filter Chips
                _buildFilterChips(),
                SizedBox(height: 30.h),

                // 3. Today Section
                _sectionHeader("TODAY"),
                const HistoryItemCard(
                  time: "14:22 PM",
                  tag: "ALGEBRA",
                  problem: "3x² + 12x - 9 = 0",
                  solution: "x = -2 ± √7",
                  isFinal: true,
                ),
                const HistoryItemCard(
                  time: "09:15 AM",
                  tag: "CALCULUS",
                  problem: "∫ (sin x + cos x) dx",
                  solution: "sin x - cos x + C",
                  isFinal: true,
                ),

                // 4. Yesterday Section
                _sectionHeader("YESTERDAY"),
                const HistoryItemCard(
                  time: "16:45 PM",
                  tag: "GEOMETRY",
                  problem: "Area of Triangle ABC",
                  solution: "42.5 cm²",
                  isFinal: false,
                ),
                const HistoryItemCard(
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, bottom: 10.h, top: 10.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: AppConstants.otherTextColor),
        hintText: "Search past solutions...",
        hintStyle: TextStyle(color: AppConstants.otherTextColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppConstants.otherTextColor.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppConstants.otherTextColor.withOpacity(0.1),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip("All History", isSelected: true),
          _filterChip("Algebra"),
          _filterChip("Calculus"),
          _filterChip("Geometry"),
          _filterChip("Trigonometry"),
          _filterChip("Statistics"),
          _filterChip("Calculus"),
          _filterChip("Geometry"),
          _filterChip("Trigonometry"),
          _filterChip("Statistics"),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 07.h),
      decoration: BoxDecoration(
        color: isSelected ? AppConstants.primaryColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}

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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 104, 171, 255).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 11.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            problem,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(15.r),
              border: !isFinal
                  ? Border(
                      left: BorderSide(
                        color: AppConstants.primaryColor,
                        width: 4.w,
                      ),
                    )
                  : null,
            ),
            child: Row(
              children: [
                if (isFinal)
                  CircleAvatar(
                    backgroundColor: AppConstants.primaryColor,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                if (isFinal) SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFinal ? "FINAL SOLUTION" : "RESULT",
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      solution,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
