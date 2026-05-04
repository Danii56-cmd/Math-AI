import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/core/theme.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/provider/profile_provider.dart';
import 'package:math_ai/services/auth_services.dart';
import 'package:math_ai/shared_widgets/custom_pop_scope.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userProfession;
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> loadUser() async {
    userName = await AuthServices.getUserName();
    userProfession = await AuthServices.getUserProfession();
    setState(() {});
  }

  Future<void> checkLogin() async {
    final loggedIn = await AuthServices.isLoggedIn();

    if (!loggedIn) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      loadUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final themeProvider = Provider.of<ThemeChangerProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    return CustomPopScope(
      child: Scaffold(
        backgroundColor: c.bg,
        appBar: AppBar(
          backgroundColor: c.card,
          shadowColor: c.subtitle,
          elevation: 0.7,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: c.iconColor),
            onPressed: () {
              final navProvider = Provider.of<NavigationProvider>(
                context,
                listen: false,
              );
              navProvider.changeIndex(0);
            },
          ),
          title: Text(
            "Math Ai",
            style: TextStyle(
              color: c.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.share_rounded, color: c.primary),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert_rounded, color: c.primary),
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

                // ── Profile Header ───────────────────────────────────────────
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
                          userName ?? "Guest User",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: c.title,
                          ),
                        ),
                        Text(
                          userProfession ?? "Profession",
                          style: TextStyle(fontSize: 14, color: c.subtitle),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ── APPEARANCE Label ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "APPEARANCE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.subtitle,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),

                // ── Appearance Card ──────────────────────────────────────────
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: c.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: c.isDark ? 0.3 : 0.08,
                        ),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: c.iconBg,
                          child: Icon(
                            Icons.dark_mode_outlined,
                            color: c.iconColor,
                          ),
                        ),
                        title: Text(
                          "Dark Mode",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: c.title,
                          ),
                        ),
                        subtitle: Text(
                          "Reduce eye strain in low light",
                          style: TextStyle(fontSize: 12, color: c.subtitle),
                        ),
                        trailing: Switch(
                          value: c.isDark,
                          thumbColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          trackColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppTheme.primary;
                            }
                            return c.isDark ? Colors.white24 : Colors.black26;
                          }),
                          trackOutlineColor: const WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          onChanged: (value) {
                            themeProvider.setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 5.h),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: c.iconBgMuted,
                          child: Icon(
                            Icons.palette_outlined,
                            color: c.iconMuted,
                          ),
                        ),
                        title: Text(
                          "App Theme",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: c.title,
                          ),
                        ),
                        subtitle: Text(
                          "Editorial Sanctuary (Default)",
                          style: TextStyle(fontSize: 12, color: c.subtitle),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: c.subtitle,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // ── PREFERENCES Label ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "PREFERENCES",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.subtitle,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),

                // ── Preferences Card ─────────────────────────────────────────
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: c.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: c.isDark ? 0.3 : 0.08,
                        ),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: c.iconBg,
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: c.iconColor,
                          ),
                        ),
                        title: Text(
                          "Notifications",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: c.title,
                          ),
                        ),
                        subtitle: Text(
                          "Daily reminders and AI updates",
                          style: TextStyle(fontSize: 12, color: c.subtitle),
                        ),
                        trailing: Switch(
                          value: profileProvider.notificationsEnabled,
                          onChanged: profileProvider.toggleNotifications,
                          thumbColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          trackColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppTheme.primary;
                            }
                            return c.isDark ? Colors.white24 : Colors.black26;
                          }),
                          trackOutlineColor: const WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: c.iconBg,
                          child: Icon(Icons.language, color: c.iconColor),
                        ),
                        title: Text(
                          "Language",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: c.title,
                          ),
                        ),
                        subtitle: Text(
                          "English (United States)",
                          style: TextStyle(fontSize: 12, color: c.subtitle),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_down,
                          color: c.subtitle,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5.h),

                // ── Logout ───────────────────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Logout"),
                          content: Text("Do you really want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: c.title),
                              ),
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
                    child: Container(
                      height: 50.h,
                      width: 100.w,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: c.title),
                          SizedBox(width: 5.w),
                          Text("Logout", style: TextStyle(color: c.title)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
