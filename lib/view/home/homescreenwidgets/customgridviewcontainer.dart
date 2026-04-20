import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_constants.dart';

class CustomGridViewContainer extends StatelessWidget {
  final icon;
  final title;
  final subtitle;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // height: 100,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: AppConstants.otherTextColor.withOpacity(0.1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 05, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(icon, height: 50, width: 50),
                SizedBox(height: 03),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 09.sp,
                    color: AppConstants.otherTextColor,
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
