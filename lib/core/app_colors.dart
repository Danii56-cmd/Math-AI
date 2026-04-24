// lib/core/app_colors.dart

import 'package:flutter/material.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/core/theme.dart';

class AppColors {
  AppColors._({
    required this.bg,
    required this.card,
    required this.title,
    required this.subtitle,
    required this.border,
    required this.iconBg,
    required this.iconColor,
    required this.iconBgMuted,
    required this.iconMuted,
    required this.primary,
    required this.surface,
    required this.surfaceVariant,
    required this.isDark,
  });

  final Color bg;
  final Color card;
  final Color title;
  final Color subtitle;
  final Color border;
  final Color iconBg;
  final Color iconColor;
  final Color iconBgMuted;
  final Color iconMuted;
  final Color primary;
  final Color surface;
  final Color surfaceVariant;
  final bool isDark;

  // lib/core/app_colors.dart

  factory AppColors.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppColors._(
      isDark: isDark,
      bg: isDark ? AppTheme.neutral : const Color(0xFFF0F4F8),
      card: isDark ? AppTheme.secondary : Colors.white,
      title: isDark ? Colors.white : Colors.black,
      subtitle: isDark ? Colors.white54 : const Color(0xFF64748B),
      border: isDark ? const Color(0xFF334155) : Colors.grey.withAlpha(20),
      iconBg: isDark
          ? AppTheme.primary.withAlpha(15)
          : AppConstants.primaryColor.withAlpha(12),
      iconColor: isDark ? AppTheme.primary : AppConstants.primaryColor,
      iconBgMuted: isDark
          ? Colors.white.withAlpha(8)
          : AppConstants.otherTextColor.withAlpha(3),
      iconMuted: isDark ? Colors.white54 : AppConstants.otherTextColor,
      surface: isDark ? AppTheme.secondary : Colors.white,
      surfaceVariant: isDark
          ? const Color(0xFF263348)
          : const Color(0xFFEEF2FF),

      // ── THIS is the key fix ───────────────────────────────────────────
      primary: isDark ? AppTheme.primary : AppConstants.primaryColor,
      // cyan #00D2FF in dark, your original blue in light
    );
  }
}
