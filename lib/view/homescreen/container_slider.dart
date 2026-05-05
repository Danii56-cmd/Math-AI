import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_constants.dart';

class ContainerSlider extends StatefulWidget {
  const ContainerSlider({super.key});

  @override
  State<ContainerSlider> createState() => _ContainerSliderState();
}

class _ContainerSliderState extends State<ContainerSlider> {
  final PageController _controller = PageController();
  int _currentIndex = 0; // Using index for discrete steps

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Slider
        SizedBox(
          height: 150.h, // Adjusted height to match your Home Page design
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            itemCount: 3, // Matches the 3 dots in your design image
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.pushNamed(context, "/solver_screen");
                  } else if (index == 1) {
                    Navigator.pushNamed(context, "/ai_chatbot_screen");
                  } else if (index == 2) {
                    Navigator.pushNamed(context, "/graphing_screen");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 150.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        // 🔹 Background Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            AppConstants.containerBg,
                            height: 150.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // 🔹 Blue Overlay
                        Container(
                          height: 150.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            // Defines the linear gradient as visualized
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                // Primary blue: Maps to rgba(0, 97, 164, 1) with 0.8 opacity
                                AppConstants.primaryColor.withValues(alpha: 0.8),
                                // Secondary purple: Maps to rgba(111, 72, 178, 1) with 0.7 opacity
                                const Color.fromARGB(179, 149, 87, 255),
                              ],
                              // Primary color holds until 50%,
                              // and secondary color starts becoming pure at 99%.
                              stops: const [0.7, 0.99],
                            ),
                          ),
                        ),

                        // 🔹 Text on top
                        Padding(
                          padding: EdgeInsets.all(15.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Get Instant Math Solutions\nwith AI",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Scan, type, or ask AI for step-\nby-step solutions",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 12.h),

        // 🔹 Dot Indicator (Capsule Style)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            bool isActive = _currentIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              // The active dot is a long capsule; inactive is a circle
              height: 06.h,
              width: isActive ? 30.w : 10.w,
              decoration: BoxDecoration(
                // Use rgba(30, 58, 138, 1) for the active state
                color: isActive
                    ? AppConstants.primaryColor
                    : const Color(
                        0xFFE5EAF2,
                      ), // Light greyish blue for inactive
                borderRadius: BorderRadius.circular(10.r),
              ),
            );
          }),
        ),
      ],
    );
  }
}
