import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/providers/language_provider.dart';
import '../data/providers/auth_provider.dart';
import '../data/providers/offers_provider.dart';
import '../data/providers/theme_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/offer_card_grid.dart';
import '../widgets/premium_invite_dialog.dart';
import '../widgets/offers_shimmer.dart';
import '../widgets/custom_search_bar.dart';
import '../theme/relevo_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'premium_screen.dart';
import '../data/models/offer_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ScrollController _scrollController;
  late final PageController _pageController;
  int _selectedCategoryIndex = 0;
  final Map<int, int> _lastAutoFetchedPages =
      {}; // Track auto-fetched pages per category index to prevent loops

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController(initialPage: _selectedCategoryIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offersState = ref.watch(offersProvider);
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).value;
    final isLoggedIn = user != null;
    final isPro =
        user != null &&
        (user.proActive == true || user.roles.contains('ADMIN'));
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
          _lastAutoFetchedPages.clear();
          ref.invalidate(offersProvider);
          try {
            await ref.read(offersProvider.future);
          } catch (_) {}
        },
        color: theme.colorScheme.primary,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Search and Category Chips (Visible to both guest and member!)
              SliverToBoxAdapter(
                child: Container(
                  color: theme.scaffoldBackgroundColor,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    bottom: 8,
                  ),
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
                            Builder(
                              builder: (context) {
                                final hasFilters =
                                    offersState.value?.sector != null ||
                                    offersState.value?.region != null ||
                                    offersState.value?.employeeRange != null ||
                                    offersState.value?.revenueRange != null ||
                                    offersState.value?.creationYearFrom !=
                                        null ||
                                    offersState.value?.creationYearTo != null;

                                return Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: hasFilters
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.outline
                                                .withOpacity(0.15),
                                      width: hasFilters ? 1.8 : 1.0,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.tune_outlined,
                                      color: hasFilters
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurface
                                                .withOpacity(0.8),
                                    ),
                                    onPressed: () {
                                      if (!isPro) {
                                        showPremiumInviteDialog(
                                          context,
                                          isLoggedIn: isLoggedIn,
                                        );
                                      } else {
                                        _showFiltersBottomSheet(context);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Horizontal Category Chips
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
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
                                    _selectedCategoryIndex = selected
                                        ? index
                                        : 0;
                                  });
                                  _pageController.animateToPage(
                                    selected ? index : 0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                labelStyle: theme.textTheme.labelMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                    ),
                                selectedColor: theme.colorScheme.primary,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : theme.colorScheme.outline.withOpacity(
                                            0.15,
                                          ),
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
            ];
          },
          body: PageView.builder(
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

                  final List<String> categoryKeys = [
                    '',
                    'HOSPITALITY',
                    'RETAIL',
                    'INDUSTRIAL',
                    'HEALTHCARE',
                    'SERVICES',
                  ];

                  final displayed = catIndex == 0
                      ? filtered
                      : filtered
                            .where(
                              (o) =>
                                  o.sector.toUpperCase().trim() ==
                                  categoryKeys[catIndex],
                            )
                            .toList();

                  final displayedOffers = isLoggedIn
                      ? displayed
                      : displayed.take(4).toList();

                  // Background pre-fetching logic:
                  // If the selected category feed is empty but more pages are available on the backend,
                  // automatically load the next page in the background.
                  final currentPage = stateData.pagination?.page ?? 1;
                  if (catIndex == _selectedCategoryIndex &&
                      displayedOffers.isEmpty &&
                      stateData.pagination?.hasNextPage == true &&
                      !stateData.isLoadingMore &&
                      isLoggedIn) {
                    final lastFetched = _lastAutoFetchedPages[catIndex] ?? 1;
                    if (currentPage >= lastFetched) {
                      _lastAutoFetchedPages[catIndex] = currentPage + 1;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          ref.read(offersProvider.notifier).fetchNextPage();
                        }
                      });
                    }
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      // Listen to scroll events on the inner CustomScrollView scrollable
                      if (scrollInfo.depth == 0 &&
                          scrollInfo is ScrollUpdateNotification) {
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                          if (isLoggedIn &&
                              !stateData.isLoadingMore &&
                              stateData.pagination?.hasNextPage == true) {
                            ref.read(offersProvider.notifier).fetchNextPage();
                          }
                        }
                      }
                      return false; // let the notification bubble up
                    },
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        if (displayedOffers.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      noOffersText,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (stateData.isLoadingMore) ...[
                                      const SizedBox(height: 24),
                                      const CircularProgressIndicator(),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          )
                        else ...[
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 16.0,
                            ),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.72,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final isLocked =
                                    isLoggedIn &&
                                    !isPro &&
                                    stateData.searchQuery.trim().isNotEmpty &&
                                    index >= 12;
                                Widget card = OfferCardGrid(
                                  offer: displayedOffers[index],
                                  isLocked: isLocked,
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
                              }, childCount: displayedOffers.length),
                            ),
                          ),
                          if (stateData.isLoadingMore)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 100),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  child: OffersShimmer(),
                ),
                error: (err, st) => Center(child: Text('Error: $err')),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentFilterState = ref.read(offersProvider).value;

    String? selectedSector = currentFilterState?.sector;
    String? selectedEmployee = currentFilterState?.employeeRange;
    String? selectedRevenue = currentFilterState?.revenueRange;

    final regionController = TextEditingController(
      text: currentFilterState?.region ?? '',
    );
    final yearFromController = TextEditingController(
      text: currentFilterState?.creationYearFrom?.toString() ?? '',
    );
    final yearToController = TextEditingController(
      text: currentFilterState?.creationYearTo?.toString() ?? '',
    );

    String getLocalizedSectorName(String sectorKey) {
      switch (sectorKey.toLowerCase()) {
        case 'technology':
        case 'tecnologia':
          return l10n.categoryTechnology;
        case 'hospitality':
        case 'hostaleria':
          return l10n.categoryHospitality;
        case 'services':
        case 'servicios':
          return l10n.categoryServices;
        case 'industrial':
        case 'industria':
          return l10n.categoryIndustrial;
        case 'retail':
        case 'comercio':
          return l10n.categoryRetail;
        case 'healthcare':
        case 'health':
        case 'salud':
          return l10n.categoryHealth;
        case 'logistics':
        case 'logistica':
          return l10n.categoryLogistics;
        case 'education':
        case 'educacion':
          return l10n.categoryEducation;
        default:
          return sectorKey;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final sheetBgColor = theme.colorScheme.surfaceContainerLow;

            return Container(
              decoration: BoxDecoration(
                color: sheetBgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Handle line
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.homeFilters,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              selectedSector = null;
                              selectedEmployee = null;
                              selectedRevenue = null;
                              regionController.clear();
                              yearFromController.clear();
                              yearToController.clear();
                            });
                          },
                          child: Text(
                            'Limpiar',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sector dropdown
                    DropdownButtonFormField<String>(
                      value: selectedSector,
                      decoration: const InputDecoration(
                        labelText: 'Sector',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      hint: const Text('Todos los sectores'),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Todos los sectores'),
                        ),
                        ...[
                          'TECHNOLOGY',
                          'HOSPITALITY',
                          'SERVICES',
                          'INDUSTRIAL',
                          'RETAIL',
                          'HEALTHCARE',
                          'LOGISTICS',
                          'EDUCATION',
                        ].map((sect) {
                          return DropdownMenuItem<String>(
                            value: sect,
                            child: Text(getLocalizedSectorName(sect)),
                          );
                        }),
                      ],
                      onChanged: (val) =>
                          setModalState(() => selectedSector = val),
                    ),
                    const SizedBox(height: 16),

                    // Region field
                    TextField(
                      controller: regionController,
                      decoration: const InputDecoration(
                        labelText: 'Región / Ubicación',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        hintText: 'Ej. Catalunya, Madrid',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Employee Range
                    DropdownButtonFormField<String>(
                      value: selectedEmployee,
                      decoration: const InputDecoration(
                        labelText: 'Número de empleados',
                        prefixIcon: Icon(Icons.people_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      hint: const Text('Cualquier tamaño'),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Cualquier tamaño'),
                        ),
                        ...Offer.employeeOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt,
                            child: Text(Offer.formatEmployeeRange(opt)),
                          );
                        }),
                      ],
                      onChanged: (val) =>
                          setModalState(() => selectedEmployee = val),
                    ),
                    const SizedBox(height: 16),

                    // Revenue Range
                    DropdownButtonFormField<String>(
                      value: selectedRevenue,
                      decoration: const InputDecoration(
                        labelText: 'Rango de facturación',
                        prefixIcon: Icon(Icons.monetization_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      hint: const Text('Cualquier facturación'),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Cualquier facturación'),
                        ),
                        ...Offer.revenueOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt,
                            child: Text(Offer.formatRevenueRange(opt)),
                          );
                        }),
                      ],
                      onChanged: (val) =>
                          setModalState(() => selectedRevenue = val),
                    ),
                    const SizedBox(height: 16),

                    // Years From and To
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: yearFromController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Año desde',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              hintText: '1800',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: yearToController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Año hasta',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              hintText: '2026',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Apply Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final region = regionController.text.trim();
                        final yearFromStr = yearFromController.text.trim();
                        final yearToStr = yearToController.text.trim();

                        final int? yearFrom = yearFromStr.isEmpty
                            ? null
                            : int.tryParse(yearFromStr);
                        final int? yearTo = yearToStr.isEmpty
                            ? null
                            : int.tryParse(yearToStr);

                        // If all filters are cleared/null, call clearFilters()
                        if (selectedSector == null &&
                            region.isEmpty &&
                            selectedEmployee == null &&
                            selectedRevenue == null &&
                            yearFrom == null &&
                            yearTo == null) {
                          ref.read(offersProvider.notifier).clearFilters();
                        } else {
                          ref
                              .read(offersProvider.notifier)
                              .updateFilters(
                                sector: selectedSector,
                                region: region.isEmpty ? null : region,
                                employeeRange: selectedEmployee,
                                revenueRange: selectedRevenue,
                                creationYearFrom: yearFrom,
                                creationYearTo: yearTo,
                              );
                        }
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Aplicar Filtros',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
