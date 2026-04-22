import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';

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
    "Trigonometry",
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: List.generate(tabList.length, (index) {
          final isActive = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTabChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              height: 32.h,
              decoration: BoxDecoration(
                color: isActive ? c.primary.withOpacity(0.15) : c.card,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isActive ? c.primary.withOpacity(0.4) : c.border,
                ),
              ),
              child: Center(
                child: Text(
                  tabList[index],
                  style: TextStyle(
                    color: isActive ? c.primary : c.subtitle,
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
