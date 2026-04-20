import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/provider/navigation_provider.dart';
// import 'package:math_ai/view/Aichatbotbotscreen/Aichatbot_screen.dart';
import 'package:math_ai/view/courselibrary/courselibrary_screen.dart';
import 'package:math_ai/view/history/history_screen.dart';
import 'package:math_ai/view/home/home_screen.dart';
import 'package:math_ai/view/profile/profile_screen.dart';
import 'package:math_ai/view/solver/solver_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    final screens = [
      HomeScreen(),
      HistoryScreen(),
      SolverScreen(),
      // AichatbotScreen(),
      CourseLibraryScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: screens[navProvider.selectedIndex],

      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.h),
        height: 65.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomIcon(
              icon: Icons.home_filled,
              isSelected: navProvider.selectedIndex == 0,
              onTap: () {
                // navProvider.clearImage(); // Clear image from solver screen
                navProvider.changeIndex(0);
              },
            ),
            BottomIcon(
              icon: Icons.history,
              isSelected: navProvider.selectedIndex == 1,
              onTap: () {
                // navProvider.clearImage(); // Clear image from solver screen
                navProvider.changeIndex(1);
              },
            ),
            BottomIcon(
              icon: Icons.smart_toy,
              label: "AI Chat",
              isSelected: navProvider.selectedIndex == 2,
              onTap: () {
                // navProvider.clearImage(); // Clear image from solver screen
                navProvider.changeIndex(2);
              },
            ),
            BottomIcon(
              icon: Icons.menu_book_rounded,
              isSelected: navProvider.selectedIndex == 3,
              onTap: () {
                // navProvider.clearImage(); // Clear image from solver screen
                navProvider.changeIndex(3);
              },
            ),
            BottomIcon(
              icon: Icons.person_outline,
              isSelected: navProvider.selectedIndex == 4,
              onTap: () {
                navProvider.clearImage(); // Clear image from solver screen
                navProvider.changeIndex(4);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final String? label;
  final VoidCallback onTap;

  const BottomIcon({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Ensures the whole area is clickable
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: isSelected
                ? AppConstants.primaryColor
                : Colors.transparent,
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 25.sp,
            ),
          ),
          // SizedBox(height: 1.h),
          if (label != null) ...[
            Text(
              label!,
              style: TextStyle(
                // Logic: If selected, use primary color (or white), else grey
                color: isSelected ? AppConstants.primaryColor : Colors.grey,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
