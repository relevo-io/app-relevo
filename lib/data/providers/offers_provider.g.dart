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
