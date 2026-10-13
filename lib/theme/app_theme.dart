import 'package:flutter/material.dart';

/// Design tokens, custom themes, and category styling based on ESTÜ corporate branding.
class AppTheme {
  AppTheme._();

  // ESTÜ Corporate Brand Colors (Eskişehir Teknik Üniversitesi)
  static const Color estuBurgundy = Color(0xFF94000D);
  static const Color estuBurgundyLight = Color(0xFFA61C24);
  static const Color estuCrimson = Color(0xFFE5383B); // True crimson for dark mode (NOT pink!)

  // Neutral Tokens - Light Mode
  static const Color lightScaffoldBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceHigher = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Neutral Tokens - Dark Mode (Obsidian / Graphite - cohesive dark palette, NOT navy!)
  static const Color darkScaffoldBg = Color(0xFF111113);
  static const Color darkSurface = Color(0xFF1A1A1E);
  static const Color darkSurfaceHigher = Color(0xFF24242A);
  static const Color darkBorder = Color(0xFF2E2E36);
  static const Color darkTextPrimary = Color(0xFFF4F4F6);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextMuted = Color(0xFF71717A);

  // Category Accent Colors
  static const Color techColor = Color(0xFF2563EB);
  static const Color artsColor = Color(0xFF9333EA);
  static const Color sportsColor = Color(0xFFEA580C);
  static const Color careerColor = Color(0xFF0D9488);

  /// Helper to get category metadata (color, icon, container color)
  static CategoryMeta getCategoryMeta(String category, bool isDark) {
    switch (category.toLowerCase()) {
      case 'technology':
        return CategoryMeta(
          color: isDark ? const Color(0xFF60A5FA) : techColor,
          backgroundColor: isDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFEFF6FF),
          icon: Icons.computer_rounded,
        );
      case 'arts':
        return CategoryMeta(
          color: isDark ? const Color(0xFFC084FC) : artsColor,
          backgroundColor: isDark
              ? const Color(0xFF2E1065).withValues(alpha: 0.5)
              : const Color(0xFFFAF5FF),
          icon: Icons.palette_rounded,
        );
      case 'sports':
        return CategoryMeta(
          color: isDark ? const Color(0xFFFB923C) : sportsColor,
          backgroundColor: isDark
              ? const Color(0xFF431407).withValues(alpha: 0.5)
              : const Color(0xFFFFF7ED),
          icon: Icons.sports_basketball_rounded,
        );
      case 'career':
        return CategoryMeta(
          color: isDark ? const Color(0xFF2DD4BF) : careerColor,
          backgroundColor: isDark
              ? const Color(0xFF042F2E).withValues(alpha: 0.5)
              : const Color(0xFFF0FDFA),
          icon: Icons.business_center_rounded,
        );
      default:
        return CategoryMeta(
          color: isDark ? estuCrimson : estuBurgundy,
          backgroundColor: isDark
              ? const Color(0xFF381014)
              : const Color(0xFFFFF1F2),
          icon: Icons.grid_view_rounded,
        );
    }
  }

  /// Light theme definition with ESTÜ Burgundy brand identity
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: estuBurgundy,
      brightness: Brightness.light,
      primary: estuBurgundy,
      surface: lightSurface,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightScaffoldBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightScaffoldBg,
        foregroundColor: lightTextPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: lightSurface,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        elevation: 2,
        indicatorColor: const Color(0xFFFFE4E6),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: estuBurgundy,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: lightTextSecondary,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  /// Dark theme definition with cohesive obsidian & ESTÜ crimson palette
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: estuCrimson,
      brightness: Brightness.dark,
      primary: estuCrimson,
      surface: darkSurface,
      surfaceContainerHighest: darkSurfaceHigher,
      outline: darkBorder,
      onSurface: darkTextPrimary,
      onSurfaceVariant: darkTextSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkScaffoldBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkScaffoldBg,
        foregroundColor: darkTextPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        elevation: 0,
        indicatorColor: const Color(0xFF381014),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: estuCrimson);
          }
          return const IconThemeData(color: darkTextMuted);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: estuCrimson,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: darkTextMuted,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkSurfaceHigher,
        contentTextStyle: const TextStyle(color: darkTextPrimary, fontFamily: 'Poppins'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: darkBorder),
        ),
      ),
    );
  }
}

/// Metadata holding styling rules for a specific category
class CategoryMeta {
  final Color color;
  final Color backgroundColor;
  final IconData icon;

  const CategoryMeta({
    required this.color,
    required this.backgroundColor,
    required this.icon,
  });
}
