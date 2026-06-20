import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/providers/auth_provider.dart';
import '../data/providers/notification_provider.dart';
import '../data/providers/chat_providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/relevo_theme.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'mentoring_screen.dart';
import 'manage_alerts_screen.dart';
import 'notifications_inbox_screen.dart';
import 'notification_preferences_screen.dart';
import '../data/providers/mentoring_provider.dart';
import 'favorites_screen.dart';
import 'premium_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;

    if (authState.hasValue && authState.value != null) {
      final user = authState.value!;

      return Scaffold(
        // Set appBar to null because MainScreen has a central AppBar
        appBar: null,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24.0, 80.0, 24.0, 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Avatar Card Block (Matches 2nd screenshot)
              RelevoCard(
                color: theme.colorScheme.surfaceContainer,
                padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
                child: Column(
                  children: [
                    // Avatar image with floating edit pencil button
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 54,
                          backgroundColor: theme.colorScheme.primary,
                          child: Text(
                            user.fullName.isNotEmpty
                                ? user.fullName.split(' ').map((e) => e.isEmpty ? '' : e[0]).take(2).join().toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfileScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00B286), // Emerald Green
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.surfaceContainer,
                                  width: 2.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Name (Centered)
                    Text(
                      user.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    // Email (Centered)
                    Text(
                      user.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Mentoring Progress Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MentoringScreen(),
                    ),
                  );
                },
                child: RelevoCard(
                  color: theme.colorScheme.surfaceContainer,
                  padding: const EdgeInsets.all(20.0),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final mentoringProgressAsync = ref.watch(mentoringProgressStateProvider);
                      final progressVal = mentoringProgressAsync.value?.progressPercentage ?? 0;

                      final String cardTitle = locale == 'ca'
                          ? 'Progrés del Mentoring'
                          : locale == 'es'
                              ? 'Progreso del Mentoring'
                              : 'Mentoring Progress';

                      final String cardDesc = locale == 'ca'
                          ? 'Completa els mòduls de mentoring per millorar les teves habilitats d\'adquisició i traspàs de negocis.'
                          : locale == 'es'
                              ? 'Completa los módulos de mentoring para mejorar tus habilidades de adquisición y traspaso de negocios.'
                              : 'Complete the mentoring modules to improve your business acquisition and transfer skills.';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    color: theme.colorScheme.primary,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    cardTitle,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                               Text(
                                 '$progressVal %',
                                 style: TextStyle(
                                   fontWeight: FontWeight.w800,
                                   fontSize: 14,
                                   color: theme.colorScheme.primary,
                                 ),
                               ),
                             ],
                           ),
                           const SizedBox(height: 16),
                           // Green Progress bar with boundary outline border to stand out from card background
                           Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(6),
                               border: Border.all(
                                 color: theme.colorScheme.outline.withValues(alpha: 0.35),
                                 width: 1.5,
                               ),
                             ),
                             child: ClipRRect(
                               borderRadius: BorderRadius.circular(4.5),
                               child: LinearProgressIndicator(
                                 value: progressVal / 100.0,
                                 minHeight: 8,
                                 backgroundColor: theme.brightness == Brightness.dark
                                     ? theme.colorScheme.surfaceContainer
                                     : const Color(0xFFECEEF0),
                                 valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                               ),
                             ),
                           ),
                          const SizedBox(height: 16),
                          Text(
                            cardDesc,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4), // Extra bottom padding inside card to avoid corner clip
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Options List Cards (separated individual rounded boxes with borders)
              _buildProfileOptionCard(
                context,
                Icons.person_outline_rounded,
                l10n.profileOptionEditProfile,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildProfileOptionCard(
                context,
                Icons.bookmark_border_outlined,
                l10n.profileOptionMyFavorites,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildProfileOptionCard(
                context,
                Icons.notifications_none_outlined,
                l10n.profileOptionSearchAlerts,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageAlertsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildProfileOptionCard(
                context,
                Icons.settings_outlined,
                l10n.profileOptionNotificationSettings,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPreferencesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildProfileOptionCard(
                context,
                Icons.school_outlined,
                l10n.profileOptionMentoringProgram,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MentoringScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildProfileOptionCard(
                context,
                user.proActive == true ? Icons.workspace_premium : Icons.workspace_premium_outlined,
                user.proActive == true
                    ? l10n.profileYouArePremiumActive
                    : l10n.profileBecomePremium,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PremiumScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildProfileOptionCard(
                context,
                Icons.logout_rounded,
                l10n.profileOptionLogout,
                isDestructive: true,
                onTap: () => ref.read(authProvider.notifier).logout(),
              ),
            ],
          ),
        ),
      );
    }

    // Guest Profile view
    final List<Map<String, String>> features = [
      {
        'title': l10n.profileFeatureMarketplaceTitle,
        'desc': l10n.profileFeatureMarketplaceDesc,
        'icon': 'business_center_outlined',
      },
      {
        'title': l10n.profileFeatureChatTitle,
        'desc': l10n.profileFeatureChatDesc,
        'icon': 'chat_bubble_outline_rounded',
      },
      {
        'title': l10n.profileFeaturePublishTitle,
        'desc': l10n.profileFeaturePublishDesc,
        'icon': 'add_circle_outline_rounded',
      },
    ];

    IconData getIcon(String name) {
      switch (name) {
        case 'business_center_outlined':
          return Icons.business_center_outlined;
        case 'chat_bubble_outline_rounded':
          return Icons.chat_bubble_outline_rounded;
        case 'add_circle_outline_rounded':
          return Icons.add_circle_outline_rounded;
        default:
          return Icons.star_border;
      }
    }

    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 80.0, 24.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.15),
                          theme.colorScheme.secondary.withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 76,
                        width: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.surfaceContainer,
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person_pin_outlined,
                          size: 38,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.profileNotRegisteredQuestion,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.profileNotRegisteredSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // Features Bento details in RelevoCard
                RelevoCard(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: features.map((feature) {
                      final isLast = features.last == feature;
                      return Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0.0 : 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                getIcon(feature['icon']!),
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feature['title']!,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feature['desc']!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                                      fontSize: 12,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(l10n.profileLoginButton),
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
                  child: Text(l10n.profileRegisterButton),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title, {
    bool isDestructive = false,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final color = isDestructive 
        ? theme.colorScheme.error 
        : (iconColor ?? theme.colorScheme.primary);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: isDestructive ? theme.colorScheme.error : theme.colorScheme.onSurface,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: isDestructive
            ? theme.colorScheme.error.withOpacity(0.4)
            : theme.colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildProfileOptionCard(
    BuildContext context,
    IconData icon,
    String title, {
    bool isDestructive = false,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return RelevoCard(
      child: _buildProfileOption(
        context,
        icon,
        title,
        isDestructive: isDestructive,
        iconColor: iconColor,
        onTap: onTap,
      ),
    );
  }
}
