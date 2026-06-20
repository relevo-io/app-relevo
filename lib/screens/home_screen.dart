import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/providers/language_provider.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/offers_provider.dart';
import '../data/providers/theme_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/offer_card_grid.dart';
import '../widgets/offers_shimmer.dart';
import '../widgets/custom_search_bar.dart';
import '../theme/relevo_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ScrollController _scrollController;
  late final PageController _pageController;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _pageController = PageController(initialPage: _selectedCategoryIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isLoggedIn = ref.read(authProvider).value != null;
    if (!isLoggedIn) return; // Do not fetch more pages if not logged in

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(offersProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final offersState = ref.watch(offersProvider);
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).value;
    final isLoggedIn = user != null;
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    final isDark = theme.brightness == Brightness.dark;

    final noOffersText = l10n.noOffersFound;

    final categories = [
      l10n.categoryAll,
      l10n.categoryHospitality,
      l10n.categoryRetail,
      l10n.categoryIndustrial,
      l10n.categoryHealth,
      l10n.categoryServices,
    ];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(offersProvider);
          try {
            await ref.read(offersProvider.future);
          } catch (_) {}
        },
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Search and Category Chips (Visible to both guest and member!)
            SliverToBoxAdapter(
              child: Container(
                color: theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.only(top: 80, bottom: 8),
                child: Column(
                  children: [
                    // Search bar + Filter slider button row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomSearchBar(
                              hintText: l10n.homeSearchHint,
                              onSearch: (query) {
                                ref
                                    .read(offersProvider.notifier)
                                    .updateSearchQuery(query);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Filter button (matching Stitch mockup)
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outline.withOpacity(0.15),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.tune_outlined,
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                              ),
                              onPressed: () {
                                // Optional filter action
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Horizontal Category Chips
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = _selectedCategoryIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              checkmarkColor: Colors.white,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategoryIndex = selected ? index : 0;
                                });
                                _pageController.animateToPage(
                                  selected ? index : 0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              labelStyle: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                              ),
                              selectedColor: theme.colorScheme.primary,
                              backgroundColor: theme.colorScheme.surfaceContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.transparent
                                      : theme.colorScheme.outline.withOpacity(0.15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Offers Grid (Refactored to PageView for sliding page transitions)
            SliverFillRemaining(
              hasScrollBody: true,
              child: PageView.builder(
                controller: _pageController,
                itemCount: categories.length,
                onPageChanged: (index) {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
                itemBuilder: (context, catIndex) {
                  return offersState.when(
                    data: (stateData) {
                      final offers = stateData.items;
                      final filtered = isLoggedIn
                          ? offers.where((o) => o.owner != user.id).toList()
                          : offers;

                      final List<String> categoryKeys = ['', 'hostaleria', 'comercio', 'industria', 'salud', 'servicios'];
                      final displayed = catIndex == 0
                          ? filtered
                          : filtered
                              .where((o) => o.sector.toLowerCase().trim() == categoryKeys[catIndex])
                              .toList();

                      final displayedOffers = isLoggedIn
                          ? displayed
                          : displayed.take(4).toList();

                      if (displayedOffers.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              noOffersText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: displayedOffers.length,
                        itemBuilder: (context, index) {
                          Widget card = OfferCardGrid(
                            offer: displayedOffers[index],
                          );
                          if (!isLoggedIn && (index == 2 || index == 3)) {
                            card = ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.0),
                                  ],
                                  stops: const [0.1, 0.9],
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstIn,
                              child: card,
                            );
                          }
                          return card;
                        },
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      child: OffersShimmer(),
                    ),
                    error: (err, st) => Center(child: Text('Error: $err')),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
