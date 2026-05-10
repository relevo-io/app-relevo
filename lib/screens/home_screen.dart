import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/providers/language_provider.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/offers_provider.dart';
import '../data/providers/theme_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/offer_card_horizontal.dart';
import '../widgets/offer_card_grid.dart';
import '../widgets/offers_shimmer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final offersState = ref.watch(offersProvider);
    
    final themeMode = ref.watch(themeStateProvider);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Relevo',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune_outlined),
            onSelected: (String value) {
              if (value == 'theme') {
                ref.read(themeStateProvider.notifier).toggleTheme();
              } else {
                final userId = ref.read(authProvider).value?.id;
                context.read<LanguageProvider>().changeLanguage(value, userId: userId);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(
                      themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      themeMode == ThemeMode.dark 
                        ? AppLocalizations.of(context)!.themeLightMode 
                        : AppLocalizations.of(context)!.themeDarkMode
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
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
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(offersProvider.future),
        color: Theme.of(context).colorScheme.secondary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Area (Search + Filters)
              Container(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? const Color(0xFF020617) 
                    : Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.homeSearchHint,
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                          prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceContainer,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                          ),
                        ),
                      ),
                    ),
                    // Filters Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.tune_outlined, size: 20),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.homeFilters, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Horizontal Section: Ofertas de empresas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.homeCompanyOffers,
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(AppLocalizations.of(context)!.homeViewAll, style: const TextStyle(color: Color(0xFF006d3d))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 240,
                child: offersState.when(
                  data: (offers) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: offers.length,
                    itemBuilder: (context, index) => OfferCardHorizontal(offer: offers[index]),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, st) => const Center(child: Text('Error')),
                ),
              ),

              const SizedBox(height: 32),

              // Grid Section: Novedades cerca de ti
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  AppLocalizations.of(context)!.homeNearbyNews,
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: offersState.when(
                  data: (offers) => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: offers.length,
                    itemBuilder: (context, index) => OfferCardGrid(offer: offers[index]),
                  ),
                  loading: () => const OffersShimmer(),
                  error: (err, st) => const Center(child: Text('Error')),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
