import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import '../data/providers/language_provider.dart';
import '../data/providers/auth_provider.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.value;
    final defaultUserName = AppLocalizations.of(context)!.profileDefaultUser;
    final String userName = currentUser?.fullName.split(' ').first ?? defaultUserName;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.language, color: Colors.white),
                onSelected: (String languageCode) {
                  final userId = ref.read(authProvider).value?.id;
                  context.read<LanguageProvider>().changeLanguage(languageCode, userId: userId);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'es',
                    child: Text(AppLocalizations.of(context)!.languageSelectorES),
                  ),
                  PopupMenuItem<String>(
                    value: 'ca',
                    child: Text(AppLocalizations.of(context)!.languageSelectorCA),
                  ),
                  PopupMenuItem<String>(
                    value: 'en',
                    child: Text(AppLocalizations.of(context)!.languageSelectorEN),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB1lf9Qoh1n0T720Rj2tD7Ekw0oCf8tAc7-p9Gta0SsObrCJUygvwTVwDVDcmQkk41_rdxZ9ddpdy58klAU6IHn9Inb7Ud__hBImONTa5bAUEWfN3ejKdopmWd-8HCNPuie0EwQKFTF-bthaE5fT-XTZe2rT14drDwBLPP1iOIVV0lCh5eR47iNrxOCG-OndWSSQel6ZG7hCk5RQ2DW0a4AtB3apq41CUw6Or3WVHoD4WeNZt1dY6UZpwvlIenHUggtTCQ7zI9EhVU',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          const Color(0xFF031632).withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF006d3d).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                AppLocalizations.of(context)!.homeMarketplaceBadge,
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.welcomeMessage(userName),
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 32,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.homeSlogan2,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: const Color(0xFF97f3b5),
                            fontSize: 32,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.homeIntro,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Stats Section
                  Row(
                    children: [
                      _buildStatCard(context, AppLocalizations.of(context)!.homeStatValue1, AppLocalizations.of(context)!.homeStatLabel1, Colors.white, const Color(0xFF031632)),
                      const SizedBox(width: 12),
                      _buildStatCard(context, AppLocalizations.of(context)!.homeStatValue2, AppLocalizations.of(context)!.homeStatLabel2, const Color(0xFF031632), Colors.white),
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  // For Owners Section
                  _buildSectionHeader(context, AppLocalizations.of(context)!.homeOwnersTitle, AppLocalizations.of(context)!.homeOwnersSubtitle),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.homeOwnersDesc,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureItem(Icons.check_circle, AppLocalizations.of(context)!.homeOwnersFeature1),
                  _buildFeatureItem(Icons.check_circle, AppLocalizations.of(context)!.homeOwnersFeature2),
                  _buildFeatureItem(Icons.check_circle, AppLocalizations.of(context)!.homeOwnersFeature3),
                  
                  const SizedBox(height: 40),
                  
                  // For Entrepreneurs Section
                  _buildSectionHeader(context, AppLocalizations.of(context)!.homeEntrepreneursTitle, AppLocalizations.of(context)!.homeEntrepreneursSubtitle),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.homeEntrepreneursDesc,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF031632).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insights, color: Color(0xFF006d3d), size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.homeEntrepreneursFeatureTitle,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(AppLocalizations.of(context)!.homeEntrepreneursFeatureDesc),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: bgColor == Colors.white ? Border.all(color: Colors.grey[200]!) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String tag, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tag,
          style: const TextStyle(
            color: Color(0xFF006d3d),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF031632),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF006d3d), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
