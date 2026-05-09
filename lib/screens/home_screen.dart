import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/providers/language_provider.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/offers_provider.dart';
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
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Relevo',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black)),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: Colors.black),
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune_outlined, color: Colors.black)),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(offersProvider.future),
        color: const Color(0xFF031632),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.homeSearchHint,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 1),
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
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
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
                        color: Colors.black,
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
                    color: Colors.black,
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
