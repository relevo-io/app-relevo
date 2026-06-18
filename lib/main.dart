import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'data/providers/language_provider.dart';
import 'data/providers/theme_provider.dart';
import 'data/providers/chat_providers.dart';
import 'screens/main_screen.dart';

void main() {
  timeago.setLocaleMessages('es', timeago.EsMessages());
  timeago.setLocaleMessages('ca', timeago.CaMessages());
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inicializar y mantener viva la conexión WebSocket de chat si el usuario está autenticado
    ref.watch(socketConnectionManagerProvider);

    final themeMode = ref.watch(themeStateProvider);
    final currentLocale = ref.watch(languageStateProvider);

    return MaterialApp(
      title: 'Relevo',
      debugShowCheckedModeBanner: false,
      locale: currentLocale,
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF031632),
          primary: const Color(0xFF031632),
          secondary: const Color(0xFF006d3d),
          surface: const Color(0xFFFFFFFF),
          surfaceContainer: const Color(0xFFFFFFFF),
          outline: const Color(0xFFCBD5E1),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme)
            .copyWith(
              displayLarge: GoogleFonts.inter(fontWeight: FontWeight.w800),
              displayMedium: GoogleFonts.inter(fontWeight: FontWeight.w800),
              displaySmall: GoogleFonts.inter(fontWeight: FontWeight.w800),
              headlineLarge: GoogleFonts.inter(fontWeight: FontWeight.w800),
              headlineMedium: GoogleFonts.inter(fontWeight: FontWeight.w800),
              headlineSmall: GoogleFonts.inter(fontWeight: FontWeight.w800),
              titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFFFFFFF),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            color: const Color(0xFF031632),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(color: Color(0xFF031632)),
          shape: const Border(
            bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF031632),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF031632),
            side: const BorderSide(color: Color(0xFF031632), width: 2),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
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
          primary: const Color(0xFF334155),
          secondary: const Color(0xFF006D3D),
          surface: const Color(0xFF0F172A),
          onSurface: const Color(0xFFF1F5F9),
          surfaceContainer: const Color(0xFF1E293B),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
            .copyWith(
              displayLarge: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                color: const Color(0xFFF1F5F9),
              ),
              displayMedium: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                color: const Color(0xFFF1F5F9),
              ),
              displaySmall: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                color: const Color(0xFFF1F5F9),
              ),
              headlineLarge: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                color: const Color(0xFFF1F5F9),
              ),
              headlineMedium: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                color: const Color(0xFFF1F5F9),
              ),
              headlineSmall: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                color: const Color(0xFFF1F5F9),
              ),
              titleLarge: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF1F5F9),
              ),
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
          selectedItemColor: Color(0xFF4ADE80),
          unselectedItemColor: Color(0xFF94A3B8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006D3D),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFF1F5F9),
            side: const BorderSide(color: Color(0xFF334155), width: 2),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
