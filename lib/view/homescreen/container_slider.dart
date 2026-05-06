import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_constants.dart';

class ContainerSlider extends StatefulWidget {
  const ContainerSlider({super.key});

  @override
  State<ContainerSlider> createState() => _ContainerSliderState();
}

class _ContainerSliderState extends State<ContainerSlider> {
  final List<Map<String, String>> sliderData = [
    {
      "title": "Solve Math Instantly with AI",
      "subtitle":
          "Scan problems or type equations to get accurate, step-by-step solutions in seconds.",
      "image": AppConstants.containerBg,
    },
    {
      "title": "Understand Concepts Clearly",
      "subtitle":
          "Break down complex formulas into simple explanations designed for better learning.",
      "image": AppConstants.containerBg,
    },
    {
      "title": "Track Progress & History",
      "subtitle":
          "Save your solutions and monitor your improvement over time with smart tracking.",
      "image": AppConstants.containerBg,
    },
  ];

  final PageController _controller = PageController();
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (!_controller.hasClients) return;

      int nextPage = _currentIndex + 1;

      if (nextPage >= sliderData.length) {
        nextPage = 0;
      }

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150.h,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            itemCount: sliderData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = sliderData[index];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    children: [
                      // Background Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          item["image"]!,
                          height: 150.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Gradient Overlay
                      Container(
                        height: 150.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppConstants.primaryColor.withValues(alpha: 0.8),
                              const Color.fromARGB(179, 149, 87, 255),
                            ],
                            stops: const [0.7, 0.99],
                          ),
                        ),
                      ),

                      // Text Content
                      Padding(
                        padding: EdgeInsets.all(15.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"]!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                item["subtitle"]!,
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
              );
            },
          ),
        ),

        SizedBox(height: 12.h),

        // Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(sliderData.length, (index) {
            bool isActive = _currentIndex == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 6.h,
              width: isActive ? 30.w : 10.w,
              decoration: BoxDecoration(
                color: isActive
                    ? AppConstants.primaryColor
                    : const Color(0xFFE5EAF2),
                borderRadius: BorderRadius.circular(10.r),
              ),
            );
          }),
        ),
      ],
    );
  }
}
