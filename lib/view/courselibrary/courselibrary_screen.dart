import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class CourseLibraryScreen extends StatefulWidget {
  const CourseLibraryScreen({super.key});

  @override
  State<CourseLibraryScreen> createState() => _CourseLibraryScreenState();
}

class _CourseLibraryScreenState extends State<CourseLibraryScreen> {
  final List<String> topics = [
    "Completing the square",
    "Parabola Graphing",
    "Factoring Polynomials",
  ];
  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(
                    fontSize: 16,
                    color: AppConstants.otherTextColor,
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppConstants.otherTextColor,
                    ),
                    hintText:
                        "Search for formulas (e.g. Quadratic,\nDerivative...)",
                    hintStyle: TextStyle(color: AppConstants.otherTextColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide(
                        color: AppConstants.otherTextColor.withAlpha(5),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {
                    print("Filter tapped");
                  },
                  child: Container(
                    height: 50.h,
                    width: 130.w,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 244, 247),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: AppConstants.otherTextColor,
                        ),
                        SizedBox(width: 05.w),
                        Text(
                          "All Topics",
                          style: TextStyle(color: AppConstants.otherTextColor),
                        ),
                      ],
                    ),
                  ),
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
                        color: const Color.fromARGB(255, 225, 239, 250),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        "FEATURED FORMULA",
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        height: 1.h,
                        color: AppConstants.otherTextColor,
                      ),
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
                    color: Colors.white,
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
                            color: Color.fromARGB(255, 248, 233, 250),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            "ALGEBRA II",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 05.h),
                      Image.asset(height: 200.h, AppConstants.problemPic),
                      Text(
                        "Solves equations in the form\n ax² + bx + c = 0",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppConstants.otherTextColor,
                        ),
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
                  style: TextStyle(
                    fontSize: 16,
                    color: AppConstants.otherTextColor,
                  ),
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
                  height: 380.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 244, 247),
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
                            color: AppConstants.primaryColor,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_note, color: Colors.white),
                              SizedBox(width: 05.w),
                              Text(
                                "Practice with this",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bookmark_add_outlined,
                                color: AppConstants.primaryColor,
                              ),
                              SizedBox(width: 05.w),
                              Text(
                                "Save to Library",
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          height: 0.5.h,
                          width: double.infinity,
                          color: AppConstants.otherTextColor.withAlpha(30),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Related Topics",
                          style: TextStyle(
                            color: AppConstants.otherTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ListView.builder(
                          shrinkWrap:
                              true, // Important: Allows the list to take only the space it needs
                          physics:
                              const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                          itemCount: topics.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(
                                vertical: -4,
                                // horizontal: -4,
                              ),
                              contentPadding: EdgeInsets.zero,
                              minLeadingWidth: 0,
                              horizontalTitleGap: 12,
                              leading: const Icon(
                                Icons.circle,
                                size: 8,
                                color: Color(0xFF6DA4FF),
                              ),
                              title: Text(
                                topics[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333D47),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
    return Container(
      height: 70.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 248, 247, 247),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: AppConstants.otherTextColor.withAlpha(03)),
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
                color: AppConstants.otherTextColor,
              ),
            ),
            Text(subtitle, style: TextStyle(fontSize: 16)),
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
    return Container(
      height: 170.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppConstants.otherTextColor.withAlpha(05)),
        color: Color.fromARGB(170, 240, 244, 247),
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
              backgroundColor: Color.fromARGB(255, 214, 229, 239),
              child: Icon(
                icon,
                color: AppConstants.otherTextColor,
                size: 30.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.otherTextColor,
              ),
            ),
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
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppConstants.otherTextColor.withAlpha(05)),
        color: Color.fromARGB(102, 247, 242, 251),
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
                color: Color.fromARGB(255, 102, 92, 105),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.change_history,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Calculus",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Study of change and motion.",
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.otherTextColor,
              ),
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
                      color: Colors.white,
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
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: AppConstants.otherTextColor,
                        ),
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
                      color: Colors.white,
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
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: AppConstants.otherTextColor,
                        ),
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
                color: AppConstants.primaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.functions, color: Colors.white, size: 30.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              "Algebra Foundations",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Variables, equations, and the\nstructural foundations of mathematical\nreasoning.",
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.otherTextColor,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Container(
                  height: 30.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      "Polynomials",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  height: 30.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      "Logarithms",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: Text(
                  "Linear",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
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
