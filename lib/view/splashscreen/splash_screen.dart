import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/services/auth_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    await Future.delayed(const Duration(seconds: 3));

    bool isLoggedIn = await AuthServices.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, "/main_screen");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  // void checkLogin(BuildContext context) async {
  //   bool isLoggedIn = await AuthServices.isLoggedIn();

  //   if (isLoggedIn) {
  //     Navigator.pushReplacementNamed(context, "/main_screen");
  //   } else {
  //     Navigator.pushReplacementNamed(context, "/login");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppConstants.appLogo, height: 200.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Math",
                style: TextStyle(
                  fontSize: 45.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15.w),
              Text(
                "AI",
                style: TextStyle(
                  fontSize: 45.sp,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.secondaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SOLVE",
                style: TextStyle(fontSize: 15.sp, color: Colors.grey),
              ),
              SizedBox(width: 10.w),
              Text(
                "•",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              SizedBox(width: 10.w),
              Text(
                "LEARN",
                style: TextStyle(fontSize: 15.sp, color: Colors.grey),
              ),
              SizedBox(width: 10.w),
              Text(
                "•",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
              SizedBox(width: 10.w),
              Text(
                "MASTER",
                style: TextStyle(fontSize: 15.sp, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
