import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/providers/language_provider.dart';
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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relevo',
      debugShowCheckedModeBanner: false,
      locale: context.watch<LanguageProvider>().currentLocale,
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
          Theme.of(context).textTheme,
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
      home: const MainScreen(),
    );
  }
}
