import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/provider/course_provider.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/shared_widgets/custom_pop_scope.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseLibraryScreen extends StatelessWidget {
  const CourseLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return CustomPopScope(
      child: Scaffold(
        backgroundColor: c.bg,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
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

                  // SEARCH
                  Consumer<CourseProvider>(
                    builder: (context, courseProvider, child) {
                      return TextField(
                        decoration: InputDecoration(
                          fillColor: c.surface,
                          filled: true,
                          prefixIcon: Icon(Icons.search, color: c.subtitle),
                          hintText:
                              "Search for courses (e.g. Algebra, Calculus...)",
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
                        onChanged: (value) =>
                            courseProvider.updateSearch(value),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),

                  // ======= FILTER =======
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
                          width: 160.w,
                          decoration: BoxDecoration(
                            color: c.surfaceVariant,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_list, color: c.subtitle),
                              SizedBox(width: 5.w),
                              Flexible(
                                child: Text(
                                  provider.selectedFilter,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: c.subtitle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),

                  // DYNAMIC COURSE LIST
                  Consumer<CourseProvider>(
                    builder: (context, provider, child) {
                      final courses = provider.filteredCourses;
                      if (courses.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: Text(
                              "No courses found",
                              style: TextStyle(color: c.subtitle, fontSize: 16),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: courses.length,
                        separatorBuilder: (_, __) => SizedBox(height: 20.h),
                        itemBuilder: (context, index) {
                          final course = courses[index];

                          if (course.category == "Algebra") {
                            return AlgebraFoundationContainer(course: course);
                          }
                          if (course.category == "Calculus") {
                            return CalculusContainer(course: course);
                          }
                          return CourseLibraryContainer(course: course);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  // FEATURED FORMULA SECTION
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
                          "FEATURED FORMULA",
                          overflow: TextOverflow.ellipsis,
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
                        SizedBox(height: 5.h),
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
                  RootsContainer(
                    title: "ZERO DISC.",
                    subtitle: "One Real Root",
                  ),
                  SizedBox(height: 10.h),
                  RootsContainer(
                    title: "NEGATIVE DISC.",
                    subtitle: "Complex Roots",
                  ),
                  SizedBox(height: 20.h),

                  // MASTER THIS CONCEPT
                  Container(
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
                                SizedBox(width: 5.w),
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
                                onTap: () =>
                                    provider.toggleSave("Quadratic Formula"),
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
                                    leading: const Icon(Icons.circle, size: 8),
                                    title: Text(topic),
                                    trailing: IconButton(
                                      icon: Icon(
                                        provider.isSaved(topic)
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                      ),
                                      onPressed: () =>
                                          provider.toggleSave(topic),
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
      ),
    );
  }
}

// HELPER: OPEN URL
Future<void> _openPlaylist(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint("Launch failed: $e");
  }
}

// WATCH PLAYLIST BUTTON
Widget _watchButton(BuildContext context, String url, CourseModel course) {
  final c = AppColors.of(context);
  return GestureDetector(
    onTap: () async {
      context.read<CourseProvider>().recordCourseView(course);
      await _openPlaylist(url);
    },
    child: Container(
      height: 38.h,
      width: 160.w,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppConstants.youtubeIcon, height: 18.h, width: 18.w),
          SizedBox(width: 5.w),
          Text(
            "Watch Playlist",
            style: TextStyle(
              color: c.title,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

// ROOTS CONTAINER
class RootsContainer extends StatelessWidget {
  final String title;
  final String subtitle;

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
        border: Border.all(color: c.subtitle.withAlpha(3)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
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

// DEFAULT COURSE CARD
class CourseLibraryContainer extends StatelessWidget {
  final CourseModel course;

  const CourseLibraryContainer({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: c.subtitle.withAlpha(5)),
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundColor: c.surface,
              child: Icon(course.icon, color: c.primary, size: 30.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              course.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              course.subtitle,
              style: TextStyle(fontSize: 16, color: c.subtitle),
            ),
            SizedBox(height: 12.h),
            _watchButton(context, course.youtubePlaylistUrl, course),
          ],
        ),
      ),
    );
  }
}

// CALCULUS SPECIAL CARD
class CalculusContainer extends StatelessWidget {
  final CourseModel course;

  const CalculusContainer({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: c.subtitle.withAlpha(50)),
        color: const Color.fromARGB(255, 248, 233, 250).withAlpha(50),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
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
              course.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              course.subtitle,
              style: TextStyle(fontSize: 16, color: c.subtitle),
            ),
            SizedBox(height: 20.h),
            // Topic chips
            ...course.topics.map(
              (topic) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Center(
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
                      children: [
                        Text(
                          topic,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: c.subtitle,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.keyboard_arrow_right, color: c.iconColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            _watchButton(context, course.youtubePlaylistUrl, course),
          ],
        ),
      ),
    );
  }
}

// ALGEBRA SPECIAL CARD
class AlgebraFoundationContainer extends StatelessWidget {
  final CourseModel course;

  const AlgebraFoundationContainer({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
              course.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: c.title,
              ),
            ),
            Text(
              course.subtitle,
              style: TextStyle(fontSize: 16, color: c.subtitle),
            ),
            SizedBox(height: 10.h),
            // Topic chips
            Wrap(
              spacing: 10.w,
              runSpacing: 8.h,
              children: course.topics
                  .map(
                    (topic) => Container(
                      height: 30.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Center(
                        child: Text(
                          topic,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: c.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 12.h),
            _watchButton(context, course.youtubePlaylistUrl, course),
          ],
        ),
      ),
    );
  }
}
