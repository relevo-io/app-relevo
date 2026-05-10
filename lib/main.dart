import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/providers/language_provider.dart';
import 'data/providers/theme_provider.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeStateProvider);

    return MaterialApp(
      title: 'Relevo',
      debugShowCheckedModeBanner: false,
      locale: context.watch<LanguageProvider>().currentLocale,
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF031632),
          primary: const Color(0xFF031632),
          secondary: const Color(0xFF006d3d),
          surface: const Color(0xFFF9F9F9),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.light().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.manrope(fontWeight: FontWeight.w800),
          displayMedium: GoogleFonts.manrope(fontWeight: FontWeight.w800),
          displaySmall: GoogleFonts.manrope(fontWeight: FontWeight.w800),
          headlineLarge: GoogleFonts.manrope(fontWeight: FontWeight.w800),
          headlineMedium: GoogleFonts.manrope(fontWeight: FontWeight.w800),
          headlineSmall: GoogleFonts.manrope(fontWeight: FontWeight.w800),
          titleLarge: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF9F9F9),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.manrope(
            color: const Color(0xFF031632),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(color: Color(0xFF031632)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF031632),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF031632),
            side: const BorderSide(color: Color(0xFF031632), width: 2),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF031632),
          brightness: Brightness.dark,
          primary: const Color(0xFF334155), // Blau grisós sobri
          secondary: const Color(0xFF006D3D),
          surface: const Color(0xFF0F172A),
          onSurface: const Color(0xFFF1F5F9),
          surfaceContainer: const Color(0xFF1E293B), // Per a targetes
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: const Color(0xFFF1F5F9)),
          displayMedium: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: const Color(0xFFF1F5F9)),
          displaySmall: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: const Color(0xFFF1F5F9)),
          headlineLarge: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: const Color(0xFFF1F5F9)),
          headlineMedium: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: const Color(0xFFF1F5F9)),
          headlineSmall: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: const Color(0xFFF1F5F9)),
          titleLarge: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: const Color(0xFFF1F5F9)),
          bodyLarge: GoogleFonts.inter(color: const Color(0xFFCBD5E1)),
          bodyMedium: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF020617),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFFF1F5F9)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF020617),
          selectedItemColor: Color(0xFF4ADE80), // Verd clar vibrant per contrastar en fosc
          unselectedItemColor: Color(0xFF94A3B8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006D3D),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFF1F5F9),
            side: const BorderSide(color: Color(0xFF334155), width: 2),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
