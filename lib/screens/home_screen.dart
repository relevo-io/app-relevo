import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/providers/language_provider.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/offers_provider.dart';
import '../data/providers/theme_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/offer_card_horizontal.dart';
import '../widgets/offer_card_grid.dart';
import '../widgets/offers_shimmer.dart';
import '../widgets/custom_search_bar.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
    final themeMode = ref.watch(themeStateProvider);
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).value;
    final isLoggedIn = user != null;
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    final noOffersText = localeCode == 'ca'
        ? 'No s\'han trobat ofertes'
        : localeCode == 'en'
            ? 'No offers found'
            : 'No se encontraron ofertas';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Relevo',
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune_outlined),
            onSelected: (String value) {
              if (value == 'theme') {
                ref.read(themeStateProvider.notifier).toggleTheme();
              } else {
                final userId = ref.read(authProvider).value?.id;
                ref
                    .read(languageStateProvider.notifier)
                    .changeLanguage(value, userId: userId);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(
                      themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      themeMode == ThemeMode.dark
                          ? AppLocalizations.of(context)!.themeLightMode
                          : AppLocalizations.of(context)!.themeDarkMode,
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
        onRefresh: () async {
          ref.invalidate(offersProvider);
          try {
            await ref.read(offersProvider.future);
          } catch (_) {}
        },
        color: theme.colorScheme.secondary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (isLoggedIn) ...[
              SliverToBoxAdapter(
                child: Container(
                  color: theme.brightness == Brightness.dark
                      ? (theme.appBarTheme.backgroundColor ??
                            const Color(0xFF020617))
                      : theme.colorScheme.surface,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: CustomSearchBar(
                          hintText: l10n.homeSearchHint,
                          onSearch: (query) {
                            ref
                                .read(offersProvider.notifier)
                                .updateSearchQuery(query);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.tune_outlined, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                l10n.homeFilters,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.homeCompanyOffers,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          l10n.homeViewAll,
                          style: TextStyle(color: theme.colorScheme.secondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 160,
                  child: offersState.when(
                    data: (stateData) {
                      final filtered = isLoggedIn
                          ? stateData.items.where((o) => o.owner != user.id).toList()
                          : stateData.items;
                      if (filtered.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              noOffersText,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) =>
                            OfferCardHorizontal(offer: filtered[index]),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, st) => const Center(child: Text('Error')),
                  ),
                ),
              ),
            ] else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.15,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.homeAboutTitle,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.homeAboutDesc,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: Text(l10n.homeAboutButton),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                child: Text(
                  AppLocalizations.of(context)!.homeNearbyNews,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            offersState.when(
              data: (stateData) {
                final offers = stateData.items;
                final filtered = isLoggedIn
                    ? offers.where((o) => o.owner != user.id).toList()
                    : offers;
                final displayedOffers = isLoggedIn
                    ? filtered
                    : filtered.take(4).toList();

                if (displayedOffers.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          noOffersText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.05,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
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
                                Colors.white.withValues(alpha: 0.0),
                              ],
                              stops: const [0.1, 0.9],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstIn,
                          child: card,
                        );
                      }
                      return card;
                    }, childCount: displayedOffers.length),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: OffersShimmer(),
                ),
              ),
              error: (err, st) =>
                  SliverToBoxAdapter(child: Center(child: Text('Error: $err'))),
            ),
            if (offersState.value?.isLoadingMore ?? false)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                ),
              ),
            if (!isLoggedIn)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.15,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.restrictedAlertTitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.restrictedAlertDesc,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: Text(l10n.profileRegisterButton),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: theme.colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: Text(l10n.profileLoginButton),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
