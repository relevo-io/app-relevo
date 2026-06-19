// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Offers)
final offersProvider = OffersProvider._();

final class OffersProvider extends $AsyncNotifierProvider<Offers, OffersState> {
  OffersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offersHash();

  @$internal
  @override
  Offers create() => Offers();
}

String _$offersHash() => r'8ff32a4fa1e7fd14349f4ef5eb4e47d23cf337bc';

abstract class _$Offers extends $AsyncNotifier<OffersState> {
  FutureOr<OffersState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<OffersState>, OffersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OffersState>, OffersState>,
              AsyncValue<OffersState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(myOffers)
final myOffersProvider = MyOffersProvider._();

final class MyOffersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Offer>>,
          List<Offer>,
          FutureOr<List<Offer>>
        >
    with $FutureModifier<List<Offer>>, $FutureProvider<List<Offer>> {
  MyOffersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myOffersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myOffersHash();

  @$internal
  @override
  $FutureProviderElement<List<Offer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Offer>> create(Ref ref) {
    return myOffers(ref);
  }
}

String _$myOffersHash() => r'0e9f2783326c4e855b95bbf91dc2821782e1de58';

@ProviderFor(FavoriteOfferIds)
final favoriteOfferIdsProvider = FavoriteOfferIdsProvider._();

final class FavoriteOfferIdsProvider
    extends $AsyncNotifierProvider<FavoriteOfferIds, Set<String>> {
  FavoriteOfferIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteOfferIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteOfferIdsHash();

  @$internal
  @override
  FavoriteOfferIds create() => FavoriteOfferIds();
}

String _$favoriteOfferIdsHash() => r'3ee5a16e6b65a42077fe83fc78867733a8e0bb18';

abstract class _$FavoriteOfferIds extends $AsyncNotifier<Set<String>> {
  FutureOr<Set<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<String>>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<String>>, Set<String>>,
              AsyncValue<Set<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(favoriteOffers)
final favoriteOffersProvider = FavoriteOffersProvider._();

final class FavoriteOffersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Offer>>,
          List<Offer>,
          FutureOr<List<Offer>>
        >
    with $FutureModifier<List<Offer>>, $FutureProvider<List<Offer>> {
  FavoriteOffersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteOffersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteOffersHash();

  @$internal
  @override
  $FutureProviderElement<List<Offer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Offer>> create(Ref ref) {
    return favoriteOffers(ref);
  }
}

String _$favoriteOffersHash() => r'a51a7861f1a911f62fd4226e5049180e5cd860cb';
