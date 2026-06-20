import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers/auth_provider.dart';
import '../data/providers/theme_provider.dart';
import '../data/providers/language_provider.dart';
import '../data/providers/notification_provider.dart';
import '../data/providers/chat_providers.dart';
import '../data/providers/navigation_providers.dart';
import '../l10n/app_localizations.dart';

import 'home_screen.dart';
import 'sell_screen.dart';
import 'inbox_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';
import 'notifications_inbox_screen.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<dynamic>>(authProvider, (previous, next) {
      if (previous?.value == null && next.value != null) {
        ref.read(mainNavigationIndexProvider.notifier).setIndex(0);
      }
    });

    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.value != null;
    final user = authState.value;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    final unreadNotifications = ref.watch(unreadNotificationsCountProvider);
    final unreadChats = ref.watch(unreadChatsCountProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      if (isLoggedIn) ...[SellScreen(), InboxScreen(), ChatListScreen()],
      const ProfileScreen(),
    ];

    final currentIndex = ref.watch(mainNavigationIndexProvider);
    int safeIndex = currentIndex;

    if (safeIndex >= screens.length) {
      safeIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mainNavigationIndexProvider.notifier).setIndex(0);
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      extendBodyBehindAppBar: true,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer.withValues(
                      alpha: 0.65,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(
                        alpha: isDark ? 0.25 : 0.45,
                      ),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                      ),
                      const Spacer(),
                      Text(
                        'Relevo',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none_outlined),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => isLoggedIn
                                      ? const NotificationsInboxScreen()
                                      : const LoginScreen(),
                                ),
                              );
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
                ),
              ),
            ),
          ),
        ),
      ),

      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Drawer(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                color: theme.colorScheme.surface.withValues(alpha: 0.75),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  children: [
                    const SizedBox(height: 32),
                    // Header Block
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: isDark ? 0.2 : 0.4,
                          ),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Relevo',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 26,
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
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ] else ...[
                            Text(
                              l10n.drawerNavigationMenu,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Modern Styled Rounded Card Helper
                    _buildDrawerCardOption(
                      context,
                      icon: Icons.home_outlined,
                      title: l10n.bottomNavHome,
                      isSelected: currentIndex == 0,
                      onTap: () {
                        ref
                            .read(mainNavigationIndexProvider.notifier)
                            .setIndex(0);
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 12),

                    if (isLoggedIn) ...[
                      _buildDrawerCardOption(
                        context,
                        icon: Icons.add_circle_outline_rounded,
                        title: l10n.bottomNavSell,
                        isSelected: currentIndex == 1,
                        onTap: () {
                          ref
                              .read(mainNavigationIndexProvider.notifier)
                              .setIndex(1);
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildDrawerCardOption(
                        context,
                        icon: Icons.description_outlined,
                        title: l10n.bottomNavInbox,
                        isSelected: currentIndex == 2,
                        onTap: () {
                          ref
                              .read(mainNavigationIndexProvider.notifier)
                              .setIndex(2);
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildDrawerCardOption(
                        context,
                        icon: Icons.chat_bubble_outline_rounded,
                        title: l10n.bottomNavChats,
                        isSelected: currentIndex == 3,
                        onTap: () {
                          ref
                              .read(mainNavigationIndexProvider.notifier)
                              .setIndex(3);
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 12),
                    ],

                    _buildDrawerCardOption(
                      context,
                      icon: Icons.person_outline_rounded,
                      title: l10n.bottomNavYou,
                      isSelected: isLoggedIn
                          ? currentIndex == 4
                          : currentIndex == 1,
                      onTap: () {
                        ref
                            .read(mainNavigationIndexProvider.notifier)
                            .setIndex(isLoggedIn ? 4 : 1);
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    // Theme Toggle Card
                    _buildDrawerCardOption(
                      context,
                      icon: isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      title: isDark ? l10n.themeLightMode : l10n.themeDarkMode,
                      isSelected: false,
                      onTap: () {
                        ref.read(themeStateProvider.notifier).toggleTheme();
                      },
                    ),
                    const SizedBox(height: 12),

                    // Expansion tile for language selector
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer.withValues(
                          alpha: 0.4,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: isDark ? 0.2 : 0.45,
                          ),
                          width: 1.5,
                        ),
                      ),
                      child: ExpansionTile(
                        leading: const Icon(Icons.language_outlined),
                        title: Text(
                          l10n.drawerLanguageSelector,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        shape: const Border(),
                        collapsedShape: const Border(),
                        children: [
                          ListTile(
                            title: const Text('Español'),
                            selected: localeCode == 'es',
                            onTap: () {
                              ref
                                  .read(languageStateProvider.notifier)
                                  .changeLanguage('es', userId: user?.id);
                            },
                          ),
                          ListTile(
                            title: const Text('Català'),
                            selected: localeCode == 'ca',
                            onTap: () {
                              ref
                                  .read(languageStateProvider.notifier)
                                  .changeLanguage('ca', userId: user?.id);
                            },
                          ),
                          ListTile(
                            title: const Text('English'),
                            selected: localeCode == 'en',
                            onTap: () {
                              ref
                                  .read(languageStateProvider.notifier)
                                  .changeLanguage('en', userId: user?.id);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    if (isLoggedIn) ...[
                      _buildDrawerCardOption(
                        context,
                        icon: Icons.favorite_border_rounded,
                        title: l10n.drawerFavorites,
                        isSelected: false,
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
                      const SizedBox(height: 12),
                      _buildDrawerCardOption(
                        context,
                        icon: Icons.notifications_active_outlined,
                        title: l10n.profileAlerts,
                        isSelected: false,
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
                      const SizedBox(height: 12),
                      _buildDrawerCardOption(
                        context,
                        icon: Icons.logout_rounded,
                        title: l10n.profileLogout,
                        isSelected: false,
                        iconColor: Colors.redAccent,
                        titleColor: Colors.redAccent,
                        onTap: () {
                          Navigator.pop(context);
                          ref.read(authProvider.notifier).logout();
                          ref
                              .read(mainNavigationIndexProvider.notifier)
                              .setIndex(0);
                        },
                      ),
                    ] else ...[
                      _buildDrawerCardOption(
                        context,
                        icon: Icons.login_rounded,
                        title: l10n.profileLoginButton,
                        isSelected: false,
                        iconColor: Colors.green,
                        titleColor: Colors.green,
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
            ),
          ),
        ),
      ),

      body: IndexedStack(index: safeIndex, children: screens),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer.withValues(
                    alpha: 0.65,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(
                      alpha: isDark ? 0.25 : 0.45,
                    ),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: NavigationBar(
                    selectedIndex: safeIndex,
                    height: 60,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    onDestinationSelected: (index) {
                      ref
                          .read(mainNavigationIndexProvider.notifier)
                          .setIndex(index);
                    },
                    indicatorColor: theme.colorScheme.primary.withOpacity(0.15),
                    destinations: [
                      NavigationDestination(
                        icon: const Icon(Icons.home_outlined),
                        selectedIcon: Icon(
                          Icons.home,
                          color: theme.colorScheme.primary,
                        ),
                        label: l10n.bottomNavHome,
                      ),
                      if (isLoggedIn) ...[
                        NavigationDestination(
                          icon: const Icon(Icons.add_circle_outline_rounded),
                          selectedIcon: Icon(
                            Icons.add_circle,
                            color: theme.colorScheme.primary,
                          ),
                          label: l10n.bottomNavSell,
                        ),
                        NavigationDestination(
                          icon: const Icon(Icons.description_outlined),
                          selectedIcon: Icon(
                            Icons.description,
                            color: theme.colorScheme.primary,
                          ),
                          label: l10n.bottomNavInbox,
                        ),
                        NavigationDestination(
                          icon: Stack(
                            children: [
                              const Icon(Icons.chat_bubble_outline_rounded),
                              if (unreadChats > 0)
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
                          label: l10n.bottomNavChats,
                        ),
                      ],
                      NavigationDestination(
                        icon: const Icon(Icons.person_outline_rounded),
                        selectedIcon: Icon(
                          Icons.person,
                          color: theme.colorScheme.primary,
                        ),
                        label: l10n.bottomNavProfile,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerCardOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final resolvedIconColor =
        iconColor ??
        (isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.7));
    final resolvedTitleColor =
        titleColor ??
        (isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface);

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : theme.colorScheme.surfaceContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.6)
              : theme.colorScheme.outline.withValues(
                  alpha: isDark ? 0.2 : 0.45,
                ),
          width: 1.5,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: Icon(icon, color: resolvedIconColor),
        title: Text(
          title,
          style: TextStyle(
            color: resolvedTitleColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        onTap: onTap,
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
    final l10n = AppLocalizations.of(context)!;

    final String title = l10n.guestAccessRestricted;
    final String description = l10n.guestAccessDesc(tabName);
    final String loginText = l10n.guestLoginButton;
    final String registerText = l10n.guestRegisterButton;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
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
