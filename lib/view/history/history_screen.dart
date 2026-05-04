import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_colors.dart';
import 'package:math_ai/models/hive_model.dart';
import 'package:math_ai/provider/history_provider.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/view/history/database_helper.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  final bool fromBottomNav;

  const HistoryScreen({super.key, this.fromBottomNav = false});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void _handleBack(BuildContext context) {
    Provider.of<NavigationProvider>(context, listen: false).changeIndex(0);
  }

  String _formatTime(DateTime? date) {
    if (date == null) return "Now";

    final hour = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
        ? 12
        : date.hour;

    final ampm = date.hour >= 12 ? "PM" : "AM";

    return "$hour:${date.minute.toString().padLeft(2, '0')} $ampm";
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _handleBack(context);
      },
      child: Scaffold(
        backgroundColor: c.bg,
        appBar: AppBar(
          backgroundColor: c.bg,
          elevation: 0.7,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: c.primary),
            onPressed: () => _handleBack(context),
          ),
          title: Text(
            "Math Ai",
            style: TextStyle(
              color: c.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),

                _buildSearchBar(context, c),
                SizedBox(height: 20.h),

                _buildFilterChips(context, c),
                SizedBox(height: 20.h),

                Expanded(
                  child: Consumer<HistoryProvider>(
                    builder: (context, provider, child) {
                      final List<HistoryModel> filtered =
                          provider.filteredHistory;

                      if (filtered.isEmpty) {
                        return const Center(child: Text("No history found"));
                      }

                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];

                          return HistoryItemCard(
                            time: _formatTime(item.createdAt),
                            tag: item.category,
                            problem: item.question,
                            solution: item.solution,
                            itemId: index.toString(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _buildSearchBar(BuildContext context, AppColors c) {
    return Consumer<HistoryProvider>(
      builder: (context, provider, child) {
        return TextField(
          onChanged: provider.updateSearch,
          style: TextStyle(color: c.title),
          decoration: InputDecoration(
            filled: true,
            fillColor: c.card,
            prefixIcon: Icon(Icons.search, color: c.subtitle),
            hintText: "Search past solutions...",
            hintStyle: TextStyle(color: c.subtitle),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: c.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: c.border),
            ),
          ),
        );
      },
    );
  }

  // ================= FILTER CHIPS =================
  Widget _buildFilterChips(BuildContext context, AppColors c) {
    return Consumer<HistoryProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip(
                c,
                "All History",
                isSelected: provider.selectedFilter == "All History",
                onTap: () => provider.changeFilter("All History"),
              ),
              _filterChip(
                c,
                "Algebra",
                isSelected: provider.selectedFilter == "Algebra",
                onTap: () => provider.changeFilter("Algebra"),
              ),
              _filterChip(
                c,
                "Calculus",
                isSelected: provider.selectedFilter == "Calculus",
                onTap: () => provider.changeFilter("Calculus"),
              ),
              _filterChip(
                c,
                "Geometry",
                isSelected: provider.selectedFilter == "Geometry",
                onTap: () => provider.changeFilter("Geometry"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(
    AppColors c,
    String label, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? c.primary : c.card,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : c.subtitle),
        ),
      ),
    );
  }
}

// ================= HISTORY CARD =================
class HistoryItemCard extends StatelessWidget {
  final String time, tag, problem, solution, itemId;

  const HistoryItemCard({
    super.key,
    required this.time,
    required this.tag,
    required this.problem,
    required this.solution,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: c.title.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: c.subtitle,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: c.primary,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Delete"),
                          content: const Text("Delete this history?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(ctx);
                                await DatabaseHelper.deleteHistory(
                                  int.parse(itemId),
                                );
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.more_vert, color: c.subtitle, size: 18.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            problem,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: c.subtitle.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: c.primary, size: 28.sp),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FINAL SOLUTION",
                      style: TextStyle(
                        color: c.primary,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      solution,
                      style: TextStyle(
                        color: c.title,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
