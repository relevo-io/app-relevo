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

  OffersState({
    required this.items,
    this.pagination,
    required this.searchQuery,
    this.isLoadingMore = false,
  });

  OffersState copyWith({
    List<Offer>? items,
    PaginationMetadata? pagination,
    String? searchQuery,
    bool? isLoadingMore,
  }) {
    return OffersState(
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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
      );

      state = AsyncValue.data(
        OffersState(
          items: [...currentState.items, ...result.items],
          pagination: result.pagination,
          searchQuery: currentState.searchQuery,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
      // Mantener el estado anterior pero sin loading
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
      );

      state = AsyncValue.data(
        OffersState(
          items: result.items,
          pagination: result.pagination,
          searchQuery: query,
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
