import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/providers/auth_provider.dart';
import '../data/providers/theme_provider.dart';
import '../data/providers/language_provider.dart';
import '../data/providers/notification_provider.dart';
import '../data/providers/chat_providers.dart';
import '../l10n/app_localizations.dart';

import 'home_screen.dart';
import 'sell_screen.dart';
import 'inbox_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';
import 'notifications_inbox_screen.dart';
import 'edit_profile_screen.dart';
import 'favorites_screen.dart';
import 'manage_alerts_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<dynamic>>(authProvider, (previous, next) {
      if (previous?.value == null && next.value != null) {
        setState(() {
          _currentIndex = 0;
        });
      }
    });

    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.value != null;
    final user = authState.value;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    // Unread counts for badges
    final unreadNotifications = ref.watch(unreadNotificationsCountProvider);
    final unreadChats = ref.watch(unreadChatsCountProvider);

    final List<Widget> screens = [
      const HomeScreen(), // Inicio
      isLoggedIn
          ? SellScreen()
          : GuestCTAScreen(
              tabName: localeCode == 'ca'
                  ? 'ofertes de venda'
                  : localeCode == 'es'
                  ? 'ofertas de venta'
                  : 'sales/offers',
            ),
      isLoggedIn
          ? InboxScreen()
          : GuestCTAScreen(
              tabName: localeCode == 'ca'
                  ? 'sol·licituds'
                  : localeCode == 'es'
                  ? 'solicitudes'
                  : 'requests',
            ),
      isLoggedIn
          ? ChatListScreen()
          : GuestCTAScreen(
              tabName: localeCode == 'ca'
                  ? 'converses'
                  : localeCode == 'es'
                  ? 'conversaciones'
                  : 'chats',
            ),
      const ProfileScreen(),
    ];

    if (_currentIndex >= screens.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        centerTitle: true,
        title: Text(
          'Relevo',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined),
                onPressed: () {
                  if (isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsInboxScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
              ),
              if (isLoggedIn && unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.12),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Relevo',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isLoggedIn) ...[
                    Text(
                      user?.fullName ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user?.email ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    Text(
                      localeCode == 'ca'
                          ? 'Menú de navegació'
                          : localeCode == 'es'
                          ? 'Menú de navegación'
                          : 'Navigation Menu',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Navigation Links
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: Text(
                localeCode == 'ca'
                    ? 'Inici'
                    : localeCode == 'es'
                    ? 'Inicio'
                    : 'Home',
              ),
              selected: _currentIndex == 0,
              selectedColor: theme.colorScheme.primary,
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline_rounded),
              title: Text(
                localeCode == 'ca'
                    ? 'Vendre'
                    : localeCode == 'es'
                    ? 'Vender'
                    : 'Sell',
              ),
              selected: _currentIndex == 1,
              selectedColor: theme.colorScheme.primary,
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l10n.bottomNavInbox),
              selected: _currentIndex == 2,
              selectedColor: theme.colorScheme.primary,
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline_rounded),
              title: Text(
                localeCode == 'ca'
                    ? 'Xats'
                    : localeCode == 'es'
                    ? 'Chats'
                    : 'Chats',
              ),
              selected: _currentIndex == 3,
              selectedColor: theme.colorScheme.primary,
              onTap: () {
                setState(() => _currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: Text(l10n.bottomNavYou),
              selected: _currentIndex == 4,
              selectedColor: theme.colorScheme.primary,
              onTap: () {
                setState(() => _currentIndex = 4);
                Navigator.pop(context);
              },
            ),

            const Divider(),

            // Theme Toggle
            ListTile(
              leading: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
              title: Text(isDark ? l10n.themeLightMode : l10n.themeDarkMode),
              onTap: () {
                ref.read(themeStateProvider.notifier).toggleTheme();
              },
            ),

            // Language Submenu
            ExpansionTile(
              leading: const Icon(Icons.language_outlined),
              title: Text(
                localeCode == 'ca'
                    ? 'Idioma'
                    : localeCode == 'es'
                    ? 'Idioma'
                    : 'Language',
              ),
              children: [
                ListTile(
                  title: const Text('Español'),
                  selected: localeCode == 'es',
                  onTap: () {
                    ref
                        .read(languageStateProvider.notifier)
                        .changeLanguage('es', userId: user?.id);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Català'),
                  selected: localeCode == 'ca',
                  onTap: () {
                    ref
                        .read(languageStateProvider.notifier)
                        .changeLanguage('ca', userId: user?.id);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('English'),
                  selected: localeCode == 'en',
                  onTap: () {
                    ref
                        .read(languageStateProvider.notifier)
                        .changeLanguage('en', userId: user?.id);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),

            const Divider(),

            // Extra actions for logged in
            if (isLoggedIn) ...[
              ListTile(
                leading: const Icon(Icons.favorite_border_rounded),
                title: Text(
                  localeCode == 'ca'
                      ? 'Preferits'
                      : localeCode == 'es'
                      ? 'Favoritos'
                      : 'Favorites',
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: Text(l10n.profileAlerts),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageAlertsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                ),
                title: Text(
                  l10n.profileLogout,
                  style: const TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(authProvider.notifier).logout();
                  setState(() => _currentIndex = 0);
                },
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.login_rounded, color: Colors.green),
                title: Text(
                  l10n.profileLoginButton,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: theme.colorScheme.primary.withOpacity(0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: theme.colorScheme.primary),
            label: localeCode == 'ca'
                ? 'Inici'
                : localeCode == 'es'
                ? 'Inicio'
                : 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(
              Icons.add_circle,
              color: theme.colorScheme.primary,
            ),
            label: localeCode == 'ca'
                ? 'Vendre'
                : localeCode == 'es'
                ? 'Vender'
                : 'Sell',
          ),
          NavigationDestination(
            icon: const Icon(Icons.description_outlined),
            selectedIcon: Icon(
              Icons.description,
              color: theme.colorScheme.primary,
            ),
            label: localeCode == 'ca'
                ? 'Sol·licituds'
                : localeCode == 'es'
                ? 'Solicitudes'
                : 'Requests',
          ),
          NavigationDestination(
            icon: Stack(
              children: [
                const Icon(Icons.chat_bubble_outline_rounded),
                if (isLoggedIn && unreadChats > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            selectedIcon: Icon(
              Icons.chat_bubble,
              color: theme.colorScheme.primary,
            ),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person, color: theme.colorScheme.primary),
            label: localeCode == 'ca'
                ? 'Perfil'
                : localeCode == 'es'
                ? 'Perfil'
                : 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Reusable Guest CTA Widget for locked tabs
class GuestCTAScreen extends StatelessWidget {
  final String tabName;
  const GuestCTAScreen({super.key, required this.tabName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localeCode = Localizations.localeOf(context).languageCode;

    final String title = localeCode == 'ca'
        ? 'Accés Restringit'
        : localeCode == 'es'
        ? 'Acceso Restringido'
        : 'Access Restricted';

    final String description = localeCode == 'ca'
        ? 'Necessites iniciar la teva sessió o registrar-te per gestionar les teves $tabName, xats i connectar amb els fundadors directament.'
        : localeCode == 'es'
        ? 'Necesitas iniciar sesión o registrarte para gestionar tus $tabName, conversaciones y conectar con los fundadores directamente.'
        : 'You need to log in or register to manage your $tabName, messages, and contact founders directly.';

    final String loginText = localeCode == 'ca'
        ? 'Iniciar sessió'
        : localeCode == 'es'
        ? 'Iniciar sesión'
        : 'Log In';
    final String registerText = localeCode == 'ca'
        ? 'Registra\'t'
        : localeCode == 'es'
        ? 'Registrarse'
        : 'Register';

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 72,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.5,
                color: theme.colorScheme.onSurface.withOpacity(0.65),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(loginText),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(registerText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
