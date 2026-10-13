import 'package:flutter/material.dart';

/// Design tokens, custom themes, and category styling based on ESTÜ corporate branding.
class AppTheme {
  AppTheme._();

  // ESTÜ Corporate Brand Colors (Eskişehir Teknik Üniversitesi)
  static const Color estuBurgundy = Color(0xFF94000D);
  static const Color estuBurgundyLight = Color(0xFFA61C24);
  static const Color estuBurgundyDark = Color(0xFFF43F5E); // For dark mode vibrancy
  static const Color estuCharcoal = Color(0xFF1E293B);
  static const Color estuGraphite = Color(0xFF334155);

  // Category Accent Colors
  static const Color techColor = Color(0xFF2563EB);
  static const Color artsColor = Color(0xFF9333EA);
  static const Color sportsColor = Color(0xFFEA580C);
  static const Color careerColor = Color(0xFF0D9488);
  static const Color defaultCategoryColor = estuBurgundy;

  /// Helper to get category metadata (color, icon, container color)
  static CategoryMeta getCategoryMeta(String category, bool isDark) {
    switch (category.toLowerCase()) {
      case 'technology':
        return CategoryMeta(
          color: isDark ? const Color(0xFF60A5FA) : techColor,
          backgroundColor: isDark
              ? const Color(0xFF1E3A8A).withValues(alpha: 0.35)
              : const Color(0xFFEFF6FF),
          icon: Icons.computer_rounded,
        );
      case 'arts':
        return CategoryMeta(
          color: isDark ? const Color(0xFFC084FC) : artsColor,
          backgroundColor: isDark
              ? const Color(0xFF581C87).withValues(alpha: 0.35)
              : const Color(0xFFFAF5FF),
          icon: Icons.palette_rounded,
        );
      case 'sports':
        return CategoryMeta(
          color: isDark ? const Color(0xFFFB923C) : sportsColor,
          backgroundColor: isDark
              ? const Color(0xFF7C2D12).withValues(alpha: 0.35)
              : const Color(0xFFFFF7ED),
          icon: Icons.sports_basketball_rounded,
        );
      case 'career':
        return CategoryMeta(
          color: isDark ? const Color(0xFF2DD4BF) : careerColor,
          backgroundColor: isDark
              ? const Color(0xFF134E4A).withValues(alpha: 0.35)
              : const Color(0xFFF0FDFA),
          icon: Icons.business_center_rounded,
        );
      default:
        return CategoryMeta(
          color: isDark ? estuBurgundyDark : estuBurgundy,
          backgroundColor: isDark
              ? const Color(0xFF881337).withValues(alpha: 0.35)
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
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8FAFC),
        foregroundColor: Color(0xFF0F172A),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
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
            color: Color(0xFF64748B),
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

  /// Dark theme definition with ESTÜ dark palette
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: estuBurgundyDark,
      brightness: Brightness.dark,
      primary: estuBurgundyDark,
      surface: const Color(0xFF1E293B),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF334155), width: 1),
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
        backgroundColor: const Color(0xFF1E293B),
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 2,
        indicatorColor: const Color(0xFF881337),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFDA4AF),
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
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
