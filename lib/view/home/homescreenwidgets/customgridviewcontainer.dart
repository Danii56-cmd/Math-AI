import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';

class CustomGridViewContainer extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const CustomGridViewContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: c.border),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(icon, height: 50, width: 50),

                SizedBox(height: 3),

                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: c.title),
                ),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 9.sp, color: c.subtitle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
