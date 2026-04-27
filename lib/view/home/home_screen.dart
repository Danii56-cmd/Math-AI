import 'dart:io';
import 'package:flutter/material.dart';
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

    return Scaffold(
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
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return CustomTabBar(
                            selectedIndex: provider.selectedTabIndex,
                            onTabChanged: (index) =>
                                context.read<HomeProvider>().changeTab(index),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // ── View All ─────────────────────────────────────────────────
              Container(
                margin: const EdgeInsets.only(left: 310),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CustomGridViewContainer(
                      icon: AppConstants.cameraIcon,
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
                      icon: AppConstants.galleryIcon,
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
                      icon: AppConstants.keyboardIcon,
                      title: "Type Problem",
                      subtitle: "Enter expression",
                      onTap: () {
                        context.read<NavigationProvider>().changeIndex(0);
                        Navigator.pushNamed(context, "/calculator_screen");
                      },
                    ),
                    CustomGridViewContainer(
                      icon: AppConstants.aiIcon,
                      title: "Ask AI Tutor",
                      subtitle: "Guided help",
                      onTap: () {
                        context.read<NavigationProvider>().changeIndex(2);
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
    );
  }
}
