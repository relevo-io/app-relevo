import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'data/providers/language_provider.dart';
import 'data/providers/theme_provider.dart';
import 'data/providers/chat_providers.dart';
import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/relevo_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_relevo/data/services/push_notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Manejando un mensaje en segundo plano: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      print('*** Error al inicializar Firebase en main(): $e');
    }
  }

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
    // Inicializar y mantener vivo el gestor de notificaciones push
    if (!kIsWeb) {
      ref.watch(notificationManagerProvider);
    }

    final themeMode = ref.watch(themeStateProvider);
    final currentLocale = ref.watch(languageStateProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Relevo',
      debugShowCheckedModeBanner: false,
      locale: currentLocale,
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: RelevoTheme.lightTheme,
      darkTheme: RelevoTheme.darkTheme,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: AnimatedTheme(
            data: Theme.of(context),
            duration: const Duration(milliseconds: 300),
            child: child!,
          ),
        );
      },
      home: const SplashScreen(),
    );
  }
}
