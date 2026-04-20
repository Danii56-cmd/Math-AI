import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/core/theme.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeChangerProvider>(context);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 38.r,
                    backgroundColor: Colors.grey[300],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.r),
                      child: Image.asset(
                        AppConstants.userProfile,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mohammad Danyal Khan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Flutter Developer",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.otherTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "APPEARANCE",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.otherTextColor,
                  ),
                ),
              ),
              SizedBox(height: 05.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(
                          255,
                          104,
                          171,
                          255,
                        ).withOpacity(0.4),
                        child: Icon(
                          Icons.dark_mode_outlined,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      title: Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Reduce eye strain in low light",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Switch(
                        value: themeProvider.themeMode == ThemeMode.dark,
                        thumbColor: MaterialStatePropertyAll(Colors.white),
                        activeTrackColor: AppConstants.primaryColor,
                        trackOutlineColor: MaterialStatePropertyAll(
                          Colors.transparent,
                        ),
                        onChanged: (value) {
                          themeProvider.setThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 05.h),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppConstants.otherTextColor
                            .withOpacity(0.03),
                        child: Icon(
                          Icons.palette_outlined,
                          color: AppConstants.otherTextColor,
                        ),
                      ),
                      title: Text(
                        "App Theme",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Editorial Sanctuary (Default)",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: AppConstants.otherTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "PREFERENCES",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.otherTextColor,
                  ),
                ),
              ),
              SizedBox(height: 05.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(
                          255,
                          104,
                          171,
                          255,
                        ).withOpacity(0.1),
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: AppConstants.otherTextColor,
                        ),
                      ),
                      title: Text(
                        "Notifications",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Daily reminders and AI updates",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Switch(
                        value: false,
                        thumbColor: MaterialStatePropertyAll(Colors.white),
                        activeTrackColor: AppConstants.primaryColor,
                        trackOutlineColor: MaterialStatePropertyAll(
                          Colors.transparent,
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    SizedBox(height: 05.h),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(
                          255,
                          104,
                          171,
                          255,
                        ).withOpacity(0.1),
                        child: Icon(
                          Icons.language,
                          color: AppConstants.otherTextColor,
                        ),
                      ),
                      title: Text(
                        "Language",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "English (United States)",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppConstants.otherTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 05.h),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    // alignment: Alignment.center,
                    height: 50.h,
                    width: 100.w,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 5.w),
                        Text("Logout"),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    // alignment: Alignment.center,
                    height: 50.h,
                    width: 130.w,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete_forever_outlined,
                          color: const Color.fromARGB(
                            255,
                            168,
                            56,
                            54,
                          ).withOpacity(0.7),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Delete Account",
                          style: TextStyle(
                            color: const Color.fromARGB(
                              255,
                              168,
                              56,
                              54,
                            ).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
