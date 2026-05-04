import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/provider/homescreen_provider.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/view/home/container_slider.dart';
import 'package:math_ai/view/home/homescreenwidgets/customgridviewcontainer.dart';
import 'package:math_ai/view/home/homescreenwidgets/customtabbar.dart';
import 'package:math_ai/view/home/homescreenwidgets/recentactivityListview.dart';
import 'package:math_ai/view/scanner/camera_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    final List recentActivity = [
      {
        "icon": AppConstants.quadraticIcon,
        "title": "Quadratic Equation",
        "subtitle": "Solved 2h ago • Algebra",
      },
      {
        "icon": AppConstants.compassIcon,
        "title": "Triangle Area",
        "subtitle": "Solved 5h ago • Geometry",
      },
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: c.bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Text(
                "Exit App",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: c.title,
                ),
              ),
              content: Text(
                "Do you really want to exit the app?",
                style: TextStyle(fontSize: 16, color: c.subtitle),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: c.iconColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 05.h,
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: c.surface,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 05.h,
                          ),
                          child: Text(
                            "Exit",
                            style: TextStyle(
                              color: c.title,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
        if (shouldExit == true) {
          // close app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: c.bg,
        appBar: AppBar(
          backgroundColor: c.card,
          elevation: 0.7,
          shadowColor: c.subtitle,
          leading: Icon(Icons.menu, color: c.primary),
          title: Text(
            "Math Ai",
            style: TextStyle(
              color: c.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Icon(Icons.notifications_outlined, color: c.subtitle),
            SizedBox(width: 20.w),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // ── Search Bar ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Consumer<HomeProvider>(
                    builder: (context, provider, child) {
                      return TextField(
                        style: TextStyle(color: c.title),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: c.card,
                          prefixIcon: Icon(Icons.search, color: c.subtitle),
                          hintText: "Search math problems...",
                          hintStyle: TextStyle(color: c.subtitle),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: c.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: c.primary.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        onChanged: (value) =>
                            context.read<HomeProvider>().updateSearch(value),
                      );
                    },
                  ),
                ),

                SizedBox(height: 25.h),
                const ContainerSlider(),
                SizedBox(height: 20.h),

                // ── Tab Bar ──────────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SizedBox(
                    height: 50,
                    child: Consumer<HomeProvider>(
                      builder: (context, provider, child) {
                        return CustomTabBar(
                          selectedIndex: provider.selectedTabIndex,
                          onTabChanged: (index) =>
                              context.read<HomeProvider>().changeTab(index),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // ── View All ─────────────────────────────────────────────────
                GestureDetector(
                  onTap: () {
                    Provider.of<NavigationProvider>(
                      context,
                      listen: false,
                    ).changeIndex(1);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 250.w),
                    alignment: Alignment.center,
                    height: 35,
                    width: 75,
                    decoration: BoxDecoration(
                      color: c.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: c.border),
                    ),
                    child: Text(
                      "View All",
                      style: TextStyle(
                        color: c.subtitle,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // ── Start Solving ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Start Solving",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: c.title,
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // ── Grid ─────────────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CustomGridViewContainer(
                        icon: Icons.camera,
                        iconColor: c.primary,
                        title: "Scan Problem",
                        subtitle: "Use your camera",
                        onTap: () async {
                          File? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraScreen(),
                            ),
                          );
                          if (result != null) {
                            context.read<NavigationProvider>().changeIndex(2);
                          }
                        },
                      ),
                      CustomGridViewContainer(
                        icon: Icons.image_outlined,
                        iconColor: Color.fromARGB(255, 145, 121, 187),
                        iconbgColor: Color.fromARGB(255, 246, 236, 255),
                        title: "Upload Image",
                        subtitle: "Pick from gallery",
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            final navProvider = Provider.of<NavigationProvider>(
                              context,
                              listen: false,
                            );
                            navProvider.setImageAndNavigate(
                              File(pickedFile.path),
                              2,
                            );
                          }
                        },
                      ),
                      CustomGridViewContainer(
                        icon: Icons.keyboard_alt_outlined,
                        iconColor: c.subtitle,
                        title: "Type Problem",
                        subtitle: "Enter expression",
                        onTap: () {
                          context.read<NavigationProvider>().changeIndex(0);
                          Navigator.pushNamed(context, "/calculator_screen");
                        },
                      ),
                      CustomGridViewContainer(
                        icon: Icons.smart_toy_outlined,
                        iconColor: c.primary,
                        title: "Ask AI Tutor",
                        subtitle: "Guided help",
                        onTap: () {
                          Navigator.pushNamed(context, "/aichatbot_screen");
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                // ── Recent Activity ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: c.title,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Consumer<HomeProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return RecentActivityListview(
                            icon: recentActivity[index]["icon"],
                            title: recentActivity[index]["title"],
                            subtitle: recentActivity[index]["subtitle"],
                          );
                        },
                      );
                    },
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
