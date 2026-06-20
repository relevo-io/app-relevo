import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RelevoTheme {
  // Brand color tokens from the Stitch designs (Dark mode first, with premium accents)
  static const Color primaryGreen = Color(0xFF1B8A5A); // Classy Pine Green for dark mode contrast (readable on dark navy)
  static const Color primaryGreenLight = Color(0xFF0C462C); // Deep Pine Green for light mode
  
  static const Color secondaryBlue = Color(0xFFB9C7E0); // Secondary cool grey/blue
  static const Color secondaryBlueLight = Color(0xFF565E74); // Muted secondary for light
  
  static const Color darkBg = Color(0xFF0B1326); // Deep Navy background
  static const Color darkSurface = Color(0xFF0B1326);
  static const Color darkSurfaceContainer = Color(0xFF171F33); // Card slate background
  static const Color darkOutline = Color(0xFF3C4A52); // Fine border grey
  static const Color darkTextPrimary = Color(0xFFDAE2FD); // Off-white
  static const Color darkTextSecondary = Color(0xFFABB9D2); // Cool grey secondary text

  static const Color lightBg = Color(0xFFF7F9FB); // Off-white background
  static const Color lightSurface = Color(0xFFF7F9FB);
  static const Color lightSurfaceContainer = Color(0xFFECEEF0); // Card container
  static const Color lightOutline = Color(0xFFBBCABF); // Border outline
  static const Color lightTextPrimary = Color(0xFF191C1E); // Off-black
  static const Color lightTextSecondary = Color(0xFF5C647A); // Cool dark grey secondary text

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: primaryGreenLight,
        onPrimary: Colors.white,
        secondary: secondaryBlueLight,
        onSecondary: Colors.white,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        surfaceContainer: lightSurfaceContainer,
        outline: lightOutline,
        onSurfaceVariant: lightTextSecondary,
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme, Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: lightTextPrimary),
        shape: Border(
          bottom: BorderSide(color: lightOutline.withOpacity(0.3), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreenLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightTextPrimary,
          side: const BorderSide(color: lightOutline, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceContainer,
        hintStyle: TextStyle(color: lightTextSecondary.withOpacity(0.5)),
        prefixIconColor: lightTextSecondary.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightOutline.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightOutline.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreenLight, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        onPrimary: Colors.black,
        secondary: secondaryBlue,
        onSecondary: Color(0xFF233144),
        surface: darkSurface,
        onSurface: darkTextPrimary,
        surfaceContainer: darkSurfaceContainer,
        outline: darkOutline,
        onSurfaceVariant: darkTextSecondary,
      ),
      textTheme: _buildTextTheme(ThemeData.dark().textTheme, Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: darkTextPrimary),
        shape: Border(
          bottom: BorderSide(color: darkOutline.withOpacity(0.2), width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBg,
        selectedItemColor: primaryGreen,
        unselectedItemColor: darkTextSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkTextPrimary,
          side: const BorderSide(color: darkOutline, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceContainer,
        hintStyle: TextStyle(color: darkTextSecondary.withOpacity(0.5)),
        prefixIconColor: darkTextSecondary.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkOutline.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkOutline.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 1.5),
        ),
      ),
    );
  }

  // Outfit font for display/headline/title, Inter for body/label styles
  static TextTheme _buildTextTheme(TextTheme base, Brightness brightness) {
    final Color textColor = brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;
    final Color secondaryTextColor = brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;

    return base.copyWith(
      displayLarge: TextStyle(fontWeight: FontWeight.w800, color: textColor),
      displayMedium: TextStyle(fontWeight: FontWeight.w800, color: textColor),
      displaySmall: TextStyle(fontWeight: FontWeight.w800, color: textColor),
      headlineLarge: TextStyle(fontWeight: FontWeight.w700, color: textColor),
      headlineMedium: TextStyle(fontWeight: FontWeight.w700, color: textColor),
      headlineSmall: TextStyle(fontWeight: FontWeight.w700, color: textColor),
      titleLarge: TextStyle(fontWeight: FontWeight.w700, color: textColor),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, color: textColor),
      titleSmall: TextStyle(fontWeight: FontWeight.w600, color: textColor),
      
      bodyLarge: TextStyle(fontWeight: FontWeight.normal, color: textColor),
      bodyMedium: TextStyle(fontWeight: FontWeight.normal, color: secondaryTextColor),
      bodySmall: TextStyle(fontWeight: FontWeight.normal, color: secondaryTextColor),
      labelLarge: TextStyle(fontWeight: FontWeight.w600, color: textColor),
      labelMedium: TextStyle(fontWeight: FontWeight.w500, color: secondaryTextColor),
      labelSmall: TextStyle(fontWeight: FontWeight.w500, color: secondaryTextColor),
    );
  }
}

/// Relevo Card Container matching the glass-card style
class RelevoCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double elevation;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;

  const RelevoCard({
    super.key,
    required this.child,
    this.color,
    this.elevation = 0,
    this.borderRadius,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final resolvedBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final resolvedBorder = border ?? Border.all(
      color: theme.colorScheme.outline.withOpacity(isDark ? 0.35 : 0.6),
      width: 1,
    );

    return Container(
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surfaceContainer,
        borderRadius: resolvedBorderRadius,
        border: resolvedBorder,
        boxShadow: elevation > 0 
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.25 : 0.04), 
                blurRadius: elevation * 4, 
                offset: Offset(0, elevation * 1.5),
              ),
            ]
          : null,
      ),
      child: ClipRRect(
        borderRadius: resolvedBorderRadius,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

/// AI Suitability Badge
class SuitabilityBadge extends StatelessWidget {
  final int score;
  const SuitabilityBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    Color color = score >= 8 
        ? const Color(0xFF10B981) 
        : score >= 5 
            ? const Color(0xFFF59E0B) 
            : const Color(0xFFEF4444);
            
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        '$score/10',
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
