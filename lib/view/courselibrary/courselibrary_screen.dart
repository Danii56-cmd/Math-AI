import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/provider/course_provider.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class CourseLibraryScreen extends StatelessWidget {
  CourseLibraryScreen({super.key});

  final List<String> topics = [
    "Completing the square",
    "Parabola Graphing",
    "Factoring Polynomials",
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c.surface,
        shadowColor: c.subtitle,
        elevation: 0.7,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: c.iconColor),
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
            color: c.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded, color: c.iconColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: c.iconColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              // vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Text(
                  "Courses Library",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Explore a curated collection of\nmathematical foundations. From\nfundamental algebra to advanced\ncalculus, access the language of logic in\nits purest form",
                  style: TextStyle(fontSize: 16, color: c.subtitle),
                ),
                SizedBox(height: 20.h),
                Consumer<CourseProvider>(
                  builder: (context, courseProvider, child) {
                    return TextField(
                      maxLines: 2,
                      decoration: InputDecoration(
                        fillColor: c.surface,
                        filled: true,
                        prefixIcon: Icon(Icons.search, color: c.subtitle),
                        hintText:
                            "Search for formulas (e.g. Quadratic,\nDerivative...)",
                        hintStyle: TextStyle(color: c.subtitle),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          borderSide: BorderSide(
                            color: c.subtitle.withAlpha(5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          borderSide: BorderSide(
                            color: c.subtitle.withAlpha(30),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.h),
                Consumer<CourseProvider>(
                  builder: (context, provider, child) {
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.r),
                            ),
                          ),
                          builder: (context) {
                            final filters = [
                              "All Topics",
                              "Algebra",
                              "Geometry",
                              "Calculus",
                              "Statistics",
                              "Trigonometry",
                            ];

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: filters.length,
                              itemBuilder: (context, index) {
                                final item = filters[index];

                                return ListTile(
                                  title: Text(item),
                                  trailing: provider.selectedFilter == item
                                      ? Icon(Icons.check, color: c.primary)
                                      : null,
                                  onTap: () {
                                    provider.changeFilter(item);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 50.h,
                        width: 130.w,
                        decoration: BoxDecoration(
                          color: c.surfaceVariant,
                          borderRadius: BorderRadius.circular(30.r),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_list, color: c.subtitle),
                            SizedBox(width: 05.w),
                            Text(
                              provider.selectedFilter,
                              style: TextStyle(color: c.subtitle),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                AlgebraFoundationContainer(),
                SizedBox(height: 20.h),
                CalculusContainer(),
                SizedBox(height: 20.h),
                CourseLibraryContainer(
                  icon: Icons.category_outlined,
                  title: "Geometry",
                  subtitle: "Shapes, dimensions, and space.",
                ),
                SizedBox(height: 20.h),
                CourseLibraryContainer(
                  icon: Icons.bar_chart,
                  title: "Statistics",
                  subtitle: "Data analysis and probability.",
                ),
                SizedBox(height: 20.h),
                CourseLibraryContainer(
                  icon: Icons.architecture,
                  title: "Trigonometry",
                  subtitle: "Relationships of triangle sides.",
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 30.h,
                      width: 160.w,
                      decoration: BoxDecoration(
                        color: c.surfaceVariant,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        "FEATURED FORMULA",
                        style: TextStyle(
                          color: c.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(height: 1.h, color: c.subtitle),
                    ),
                  ],
                ),
                Text(
                  "The Quadratic Formula",
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 310.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 180.w),
                        child: Container(
                          margin: EdgeInsets.only(top: 20.h),
                          alignment: Alignment.center,
                          height: 30.h,
                          width: 110.w,
                          decoration: BoxDecoration(
                            color: c.surfaceVariant,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            "ALGEBRA II",
                            style: TextStyle(
                              color: c.subtitle,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 05.h),
                      Image.asset(height: 200.h, AppConstants.problemPic),
                      Text(
                        "Solves equations in the form\n ax² + bx + c = 0",
                        style: TextStyle(fontSize: 16, color: c.subtitle),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "How it works",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "The quadratic formula is used to find the roots of a quadratic equation. It provides the exact points where the parabola crosses the x-axis. The term inside the square root, b² - 4ac, is called the discriminant, and determines the nature of the roots.",
                  style: TextStyle(fontSize: 16, color: c.subtitle),
                ),
                SizedBox(height: 10.h),
                RootsContainer(
                  title: "POSITIVE DISC.",
                  subtitle: "Two Real Roots",
                ),
                SizedBox(height: 10.h),
                RootsContainer(title: "ZERO DISC.", subtitle: "One Real Root"),
                SizedBox(height: 10.h),
                RootsContainer(
                  title: "NEGATIVE DISC.",
                  subtitle: "Complex Roots",
                ),
                SizedBox(height: 20.h),
                Container(
                  height: 440.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: c.surfaceVariant,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Master this concept",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: c.primary,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_note, color: c.surface),
                              SizedBox(width: 05.w),
                              Text(
                                "Practice with this",
                                style: TextStyle(
                                  color: c.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Consumer<CourseProvider>(
                          builder: (context, provider, child) {
                            final isSaved = provider.isSaved(
                              "Quadratic Formula",
                            );

                            return GestureDetector(
                              onTap: () {
                                provider.toggleSave("Quadratic Formula");
                              },
                              child: Container(
                                height: 50.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: c.surface,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isSaved
                                          ? Icons.bookmark
                                          : Icons.bookmark_add_outlined,
                                      color: c.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      isSaved ? "Saved" : "Save to Library",
                                      style: TextStyle(color: c.primary),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          height: 0.5.h,
                          width: double.infinity,
                          color: c.subtitle.withAlpha(30),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Related Topics",
                          style: TextStyle(
                            color: c.subtitle,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Consumer<CourseProvider>(
                          builder: (context, provider, child) {
                            final topics = provider.filteredTopics;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: topics.length,
                              itemBuilder: (context, index) {
                                final topic = topics[index];
                                return ListTile(
                                  leading: Icon(Icons.circle, size: 8),
                                  title: Text(topic),
                                  trailing: IconButton(
                                    icon: Icon(
                                      provider.isSaved(topic)
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                    ),
                                    onPressed: () {
                                      provider.toggleSave(topic);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
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

class RootsContainer extends StatelessWidget {
  final title;
  final subtitle;
  const RootsContainer({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      height: 70.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: c.subtitle.withAlpha(03)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: c.subtitle,
              ),
            ),
            Text(subtitle, style: TextStyle(fontSize: 16, color: c.title)),
          ],
        ),
      ),
    );
  }
}

class CourseLibraryContainer extends StatelessWidget {
  final icon;
  final title;
  final subtitle;
  const CourseLibraryContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      height: 170.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: c.subtitle.withAlpha(05)),
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundColor: c.surfaceVariant,
              child: Icon(icon, color: c.primary, size: 30.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(subtitle, style: TextStyle(fontSize: 16, color: c.subtitle)),
          ],
        ),
      ),
    );
  }
}

class CalculusContainer extends StatelessWidget {
  const CalculusContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: c.subtitle.withAlpha(50)),
        color: Color.fromARGB(255, 248, 233, 250).withAlpha(50),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 50.h,
              width: 55.w,
              decoration: BoxDecoration(
                color: c.surfaceVariant,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.change_history, color: c.primary, size: 30.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              "Calculus",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Study of change and motion.",
              style: TextStyle(fontSize: 16, color: c.subtitle),
            ),
            SizedBox(height: 20.h),
            Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    height: 40.h,
                    width: 250.w,
                    decoration: BoxDecoration(
                      color: c.surface,
                      border: Border.all(color: c.subtitle.withAlpha(50)),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      // mainAxisAlignment:
                      // MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Integrals",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: c.subtitle,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_right, color: c.iconColor),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    height: 40.h,
                    width: 250.w,
                    decoration: BoxDecoration(
                      color: c.surface,
                      border: Border.all(color: c.subtitle.withAlpha(50)),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      // mainAxisAlignment:
                      // MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Derivatives",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: c.subtitle,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_right, color: c.iconColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AlgebraFoundationContainer extends StatelessWidget {
  const AlgebraFoundationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 179, 209, 245),
            Color.fromARGB(255, 231, 239, 245),
          ],
          stops: [0.0, 0.4],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: c.surfaceVariant,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.functions, color: c.primary, size: 30.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              "Algebra Foundations",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: c.title,
              ),
            ),
            Text(
              "Variables, equations, and the\nstructural foundations of mathematical\nreasoning.",
              style: TextStyle(fontSize: 16, color: c.subtitle),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Container(
                  height: 30.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      "Polynomials",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: c.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  height: 30.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      "Logarithms",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: c.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Container(
              height: 30.h,
              width: 70.w,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: Text(
                  "Linear",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: c.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
