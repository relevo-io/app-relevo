import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/auth_provider.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.value != null;

    ref.listen(authProvider, (previous, next) {
      final wasLoggedIn = previous?.value != null;
      final nowLoggedIn = next.value != null;

      if (wasLoggedIn != nowLoggedIn) {
        setState(() {
          if (nowLoggedIn) {
            _currentIndex = _currentIndex == 1 ? 3 : 0;
          } else {
            _currentIndex = _currentIndex == 3 ? 1 : 0;
          }
        });
      }
    });

    final screens = [
      const HomeScreen(),
      if (isLoggedIn) const Scaffold(body: Center(child: Text('Vender'))),
      if (isLoggedIn) const Scaffold(body: Center(child: Text('Mensajes'))),
      const ProfileScreen(),
    ];

    final l10n = AppLocalizations.of(context)!;
    final menuItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home),
        label: l10n.bottomNavHome,
      ),
      if (isLoggedIn) ...[
        BottomNavigationBarItem(
          icon: const Icon(Icons.add_circle_outline),
          activeIcon: const Icon(Icons.add_circle),
          label: l10n.bottomNavSell,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.mail_outline),
          activeIcon: const Icon(Icons.mail),
          label: l10n.bottomNavInbox,
        ),
      ],
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: const Icon(Icons.person),
        label: l10n.bottomNavYou,
      ),
    ];

    if (_currentIndex >= screens.length) {
      _currentIndex = screens.length - 1;
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: menuItems,
      ),
    );
  }
}
