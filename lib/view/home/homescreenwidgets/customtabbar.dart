import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_constants.dart';

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const CustomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  final List<String> tabList = const [
    "Home",
    "Algebra",
    "Calculus",
    "Geometry",
    "Trigonometry", // Added more to test scrolling
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: List.generate(tabList.length, (index) {
          bool isActive = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTabChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 12.w), // Spacing between chips
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              height: 30.h,
              decoration: BoxDecoration(
                // rgba(30, 58, 138, 1) when active, subtle grey when inactive
                color: isActive
                    ? AppConstants.otherTextColor.withOpacity(0.08)
                    : AppConstants.otherTextColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),

              child: Center(
                child: Text(
                  tabList[index],
                  style: TextStyle(
                    color: isActive
                        ? AppConstants.otherTextColor
                        : AppConstants.otherTextColor,
                    fontSize: 13.sp,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
