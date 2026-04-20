import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/view/home/container_slider.dart';
import 'package:math_ai/view/home/homescreenwidgets/customgridviewcontainer.dart';
import 'package:math_ai/view/home/homescreenwidgets/customtabbar.dart';
import 'package:math_ai/view/home/homescreenwidgets/recentactivityListview.dart';
import 'package:math_ai/view/scanner/camera_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    int _selectedTabIndex = 0;
    List recentActivity = [
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
      appBar: AppBar(
        leading: Icon(Icons.menu, color: AppConstants.secondaryColor),
        title: Text(
          "Math Ai",
          style: TextStyle(
            color: AppConstants.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Icon(
            Icons.notifications_outlined,
            color: Color.fromARGB(255, 148, 163, 184),
          ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppConstants.otherTextColor,
                    ),
                    hintText: "Search math problems...",
                    hintStyle: TextStyle(color: AppConstants.otherTextColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppConstants.otherTextColor.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppConstants.otherTextColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              // PageView.Builder for the Slider and Container
              const ContainerSlider(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return CustomTabBar(
                        selectedIndex: _selectedTabIndex,
                        onTabChanged: (index) {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                          // This is where you will eventually filter your math problems
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(left: 310),
                alignment: Alignment.center,
                height: 35,
                width: 75,
                decoration: BoxDecoration(
                  color: AppConstants.otherTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "View All",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Start Solving",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 20.w),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2, // 2 items per row
                  shrinkWrap:
                      true, // Crucial since it's inside a Column/Scrollview
                  physics:
                      const NeverScrollableScrollPhysics(), // Parent handles scrolling
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
                          // ✅ Switch to Solver tab (index 3)
                          // setState(() {
                          //   currentIndex = 3;
                          //   capturedImage = result; // store globally or in state
                          // });
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
                            2, // 👈 Solver tab index
                          );
                        }
                      },
                    ),
                    CustomGridViewContainer(
                      icon: AppConstants.keyboardIcon,
                      title: "Type Problem",
                      subtitle: "Enter expression",
                      onTap: () {},
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return RecentActivityListview(
                      icon: recentActivity[index]["icon"],
                      title: recentActivity[index]["title"],
                      subtitle: recentActivity[index]["subtitle"],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
