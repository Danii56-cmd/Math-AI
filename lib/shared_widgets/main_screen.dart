import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/view/courselibrary/courselibrary_screen.dart';
import 'package:math_ai/view/history/history_screen.dart';
import 'package:math_ai/view/home/home_screen.dart';
import 'package:math_ai/view/profile/profile_screen.dart';
import 'package:math_ai/view/solver/solver_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // Screens list outside build so it's not recreated on every rebuild
  static final List<Widget> _screens = [
    HomeScreen(),
    HistoryScreen(),
    SolverScreen(expression: ""),
    CourseLibraryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      // ── Consumer only wraps what actually needs to rebuild ──
      body: Consumer<NavigationProvider>(
        builder: (context, nav, child) {
          if (nav.selectedIndex == 2) {
            return SolverScreen(
              key: ValueKey('${nav.expression}_${nav.capturedImage?.path}'),
              expression: nav.expression ?? "",
            );
          }
          return _screens[nav.selectedIndex];
        },
      ),

      bottomNavigationBar: Consumer<NavigationProvider>(
        builder: (context, nav, child) {
          return Container(
            margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.h),
            height: 65.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(
                    Theme.of(context).brightness == Brightness.dark ? 10 : 8,
                  ),
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
                  isSelected: nav.selectedIndex == 0,
                  onTap: () =>
                      context.read<NavigationProvider>().changeIndex(0),
                ),
                BottomIcon(
                  icon: Icons.history,
                  isSelected: nav.selectedIndex == 1,
                  onTap: () =>
                      context.read<NavigationProvider>().changeIndex(1),
                ),
                BottomIcon(
                  icon: Icons.smart_toy,
                  label: "AI Chat",
                  isSelected: nav.selectedIndex == 2,
                  onTap: () =>
                      context.read<NavigationProvider>().changeIndex(2),
                ),
                BottomIcon(
                  icon: Icons.menu_book_rounded,
                  isSelected: nav.selectedIndex == 3,
                  onTap: () =>
                      context.read<NavigationProvider>().changeIndex(3),
                ),
                BottomIcon(
                  icon: Icons.person_outline,
                  isSelected: nav.selectedIndex == 4,
                  onTap: () =>
                      context.read<NavigationProvider>().changeIndex(4),
                ),
              ],
            ),
          );
        },
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
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: isSelected
                ? colorScheme.primary
                : Colors.transparent,
            child: Icon(
              icon,
              color: isSelected
                  ? colorScheme.surface
                  : colorScheme.onSurface.withAlpha(60),
              size: 25.sp,
            ),
          ),

          if (label != null) ...[
            SizedBox(height: 2.h),
            Text(
              label!,
              style: TextStyle(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(60),
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
