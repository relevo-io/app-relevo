import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/offer_model.dart';
import '../models/pagination_model.dart';
import '../services/offer_service.dart';
import 'auth_provider.dart';

part 'offers_provider.g.dart';

class OffersState {
  final List<Offer> items;
  final PaginationMetadata? pagination;
  final String searchQuery;
  final bool isLoadingMore;
  final String? sector;
  final String? region;
  final String? employeeRange;
  final String? revenueRange;
  final int? creationYearFrom;
  final int? creationYearTo;

  OffersState({
    required this.items,
    this.pagination,
    required this.searchQuery,
    this.isLoadingMore = false,
    this.sector,
    this.region,
    this.employeeRange,
    this.revenueRange,
    this.creationYearFrom,
    this.creationYearTo,
  });

  OffersState copyWith({
    List<Offer>? items,
    PaginationMetadata? pagination,
    String? searchQuery,
    bool? isLoadingMore,
    String? sector,
    String? region,
    String? employeeRange,
    String? revenueRange,
    int? creationYearFrom,
    int? creationYearTo,
    bool clearSector = false,
    bool clearRegion = false,
    bool clearEmployeeRange = false,
    bool clearRevenueRange = false,
    bool clearCreationYearFrom = false,
    bool clearCreationYearTo = false,
  }) {
    return OffersState(
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      sector: clearSector ? null : (sector ?? this.sector),
      region: clearRegion ? null : (region ?? this.region),
      employeeRange: clearEmployeeRange ? null : (employeeRange ?? this.employeeRange),
      revenueRange: clearRevenueRange ? null : (revenueRange ?? this.revenueRange),
      creationYearFrom: clearCreationYearFrom ? null : (creationYearFrom ?? this.creationYearFrom),
      creationYearTo: clearCreationYearTo ? null : (creationYearTo ?? this.creationYearTo),
    );
  }
}

@riverpod
class Offers extends _$Offers {
  @override
  FutureOr<OffersState> build() async {
    final user = ref.watch(authProvider).value;
    final excludeOwnerId = user?.id;

    final result = await ref.read(offerServiceProvider).getOffers(
      page: 1,
      limit: 12,
      search: '',
      excludeOwnerId: excludeOwnerId,
    );

    return OffersState(
      items: result.items,
      pagination: result.pagination,
      searchQuery: '',
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    if (currentState == null) return;
    if (currentState.isLoadingMore) return;
    if (currentState.pagination != null && !currentState.pagination!.hasNextPage) return;

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final user = ref.read(authProvider).value;
      final excludeOwnerId = user?.id;
      final nextPage = (currentState.pagination?.page ?? 1) + 1;

      final result = await ref.read(offerServiceProvider).getOffers(
        page: nextPage,
        limit: 12,
        search: currentState.searchQuery,
        excludeOwnerId: excludeOwnerId,
        sector: currentState.sector,
        region: currentState.region,
        employeeRange: currentState.employeeRange,
        revenueRange: currentState.revenueRange,
        creationYearFrom: currentState.creationYearFrom,
        creationYearTo: currentState.creationYearTo,
      );

      state = AsyncValue.data(
        OffersState(
          items: [...currentState.items, ...result.items],
          pagination: result.pagination,
          searchQuery: currentState.searchQuery,
          isLoadingMore: false,
          sector: currentState.sector,
          region: currentState.region,
          employeeRange: currentState.employeeRange,
          revenueRange: currentState.revenueRange,
          creationYearFrom: currentState.creationYearFrom,
          creationYearTo: currentState.creationYearTo,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> updateSearchQuery(String query) async {
    final currentState = state.value;
    if (currentState != null && currentState.searchQuery == query) return;

    state = const AsyncValue.loading();
    try {
      final user = ref.read(authProvider).value;
      final excludeOwnerId = user?.id;

      final result = await ref.read(offerServiceProvider).getOffers(
        page: 1,
        limit: 12,
        search: query,
        excludeOwnerId: excludeOwnerId,
        sector: currentState?.sector,
        region: currentState?.region,
        employeeRange: currentState?.employeeRange,
        revenueRange: currentState?.revenueRange,
        creationYearFrom: currentState?.creationYearFrom,
        creationYearTo: currentState?.creationYearTo,
      );

      state = AsyncValue.data(
        OffersState(
          items: result.items,
          pagination: result.pagination,
          searchQuery: query,
          sector: currentState?.sector,
          region: currentState?.region,
          employeeRange: currentState?.employeeRange,
          revenueRange: currentState?.revenueRange,
          creationYearFrom: currentState?.creationYearFrom,
          creationYearTo: currentState?.creationYearTo,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateFilters({
    String? sector,
    String? region,
    String? employeeRange,
    String? revenueRange,
    int? creationYearFrom,
    int? creationYearTo,
  }) async {
    final currentState = state.value;
    if (currentState == null) return;

    state = const AsyncValue.loading();
    try {
      final user = ref.read(authProvider).value;
      final excludeOwnerId = user?.id;

      final result = await ref.read(offerServiceProvider).getOffers(
        page: 1,
        limit: 12,
        search: currentState.searchQuery,
        excludeOwnerId: excludeOwnerId,
        sector: sector,
        region: region,
        employeeRange: employeeRange,
        revenueRange: revenueRange,
        creationYearFrom: creationYearFrom,
        creationYearTo: creationYearTo,
      );

      state = AsyncValue.data(
        OffersState(
          items: result.items,
          pagination: result.pagination,
          searchQuery: currentState.searchQuery,
          sector: sector,
          region: region,
          employeeRange: employeeRange,
          revenueRange: revenueRange,
          creationYearFrom: creationYearFrom,
          creationYearTo: creationYearTo,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearFilters() async {
    final currentState = state.value;
    if (currentState == null) return;

    state = const AsyncValue.loading();
    try {
      final user = ref.read(authProvider).value;
      final excludeOwnerId = user?.id;

      final result = await ref.read(offerServiceProvider).getOffers(
        page: 1,
        limit: 12,
        search: currentState.searchQuery,
        excludeOwnerId: excludeOwnerId,
      );

      state = AsyncValue.data(
        OffersState(
          items: result.items,
          pagination: result.pagination,
          searchQuery: currentState.searchQuery,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
Future<List<Offer>> myOffers(Ref ref) async {
  final user = ref.watch(authProvider).value;
  if (user == null) return [];
  return ref.watch(offerServiceProvider).getMyOffers();
}

@riverpod
class FavoriteOfferIds extends _$FavoriteOfferIds {
  @override
  FutureOr<Set<String>> build() async {
    final user = ref.watch(authProvider).value;
    if (user == null) return {};
    try {
      final result = await ref.watch(offerServiceProvider).getFavoriteOffers();
      return result.map((o) => o.id).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> toggleFavorite(String offerId) async {
    final current = state.value ?? {};
    final isFav = current.contains(offerId);

    // Actualización optimista de la UI
    final updated = Set<String>.from(current);
    if (isFav) {
      updated.remove(offerId);
    } else {
      updated.add(offerId);
    }
    state = AsyncValue.data(updated);

    try {
      if (isFav) {
        await ref.read(offerServiceProvider).removeFavorite(offerId);
      } else {
        await ref.read(offerServiceProvider).addFavorite(offerId);
      }
      ref.invalidate(favoriteOffersProvider);
    } catch (e) {
      // Revertir en caso de error
      state = AsyncValue.data(current);
      rethrow;
    }
  }
}

@riverpod
Future<List<Offer>> favoriteOffers(Ref ref) async {
  final user = ref.watch(authProvider).value;
  if (user == null) return [];
  return ref.watch(offerServiceProvider).getFavoriteOffers();
}
