import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    final c = AppColors.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50.h),
            Image.asset(AppConstants.appLogo, height: 150.h, width: 150.w),
            SizedBox(height: 10.h),
            Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: c.title,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Please enter your details to continue",
              style: TextStyle(fontSize: 16.sp, color: c.subtitle),
            ),
            SizedBox(height: 50.h),
            // Username
            TextFormField(
              controller: userNameController,
              decoration: InputDecoration(
                labelText: "Enter Your Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(color: c.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(color: c.primary),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Email
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Please enter your Profession",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(color: c.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(color: c.primary),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 100.w,
                ),
              ),
              onPressed: () async {
                final name = userNameController.text.trim();
                final profession = emailController.text.trim();

                if (name.isEmpty || profession.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                final prefs = await SharedPreferences.getInstance();

                await prefs.setString("userName", name);
                await prefs.setString("userProfession", profession);
                await prefs.setBool("isLoggedIn", true);

                Navigator.pushReplacementNamed(context, "/main_screen");
              },
              child: const Text("Continue"),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
