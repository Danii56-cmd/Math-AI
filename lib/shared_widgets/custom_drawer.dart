import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/services/auth_services.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? userName;
  String? userProfession;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final name = await AuthServices.getUserName();
    final profession = await AuthServices.getUserProfession();

    if (!mounted) return;
    setState(() {
      userName = name;
      userProfession = profession;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Drawer(
      backgroundColor: c.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      width: 250.w,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30.h),
            // Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundImage: AssetImage(AppConstants.userProfile),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: 220.w,
                  child: Text(
                    userName ?? "Guest User",
                    style: TextStyle(
                      color: c.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  userProfession ?? "Profession",
                  style: TextStyle(color: c.subtitle, fontSize: 12),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            //  Home
            ListTile(
              leading: Icon(Icons.home_filled, color: c.iconColor),
              title: Text("Home", style: TextStyle(color: c.title)),
              onTap: () {
                Navigator.pop(context);
                Provider.of<NavigationProvider>(
                  context,
                  listen: false,
                ).changeIndex(0);
              },
            ),

            //  Scanner
            ListTile(
              leading: Icon(Icons.camera, color: c.iconColor),
              title: Text("Scan Math", style: TextStyle(color: c.title)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/camera_screen");
              },
            ),

            //  AI Chatbot
            ListTile(
              leading: Icon(Icons.smart_toy_outlined, color: c.iconColor),
              title: Text("AI Assistant", style: TextStyle(color: c.title)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/aichatbot_screen");
              },
            ),

            //  Calculator
            ListTile(
              leading: Icon(Icons.calculate_outlined, color: c.iconColor),
              title: Text("Calculator", style: TextStyle(color: c.title)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/calculator_screen");
              },
            ),

            //  History
            ListTile(
              leading: Icon(Icons.history, color: c.iconColor),
              title: Text("History", style: TextStyle(color: c.title)),
              onTap: () {
                Navigator.pop(context);
                Provider.of<NavigationProvider>(
                  context,
                  listen: false,
                ).changeIndex(1);
              },
            ),

            //  Profile
            ListTile(
              leading: Icon(Icons.person_outline, color: c.iconColor),
              title: Text("Profile", style: TextStyle(color: c.title)),
              onTap: () {
                Navigator.pop(context);
                Provider.of<NavigationProvider>(
                  context,
                  listen: false,
                ).changeIndex(4);
              },
            ),
            Divider(color: c.border),
            SizedBox(height: 30.h),
            //  Logout
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                bool? confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Logout"),
                    content: Text("Do you really want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Cancel", style: TextStyle(color: c.title)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await AuthServices.logout();
                  if (!mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/startup_screen",
                    (route) => false,
                  );
                }
              },
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Text(
                "Math AI v1.0",
                style: TextStyle(color: c.subtitle, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
