// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(offers)
final offersProvider = OffersProvider._();

final class OffersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Offer>>,
          List<Offer>,
          FutureOr<List<Offer>>
        >
    with $FutureModifier<List<Offer>>, $FutureProvider<List<Offer>> {
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
  $FutureProviderElement<List<Offer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Offer>> create(Ref ref) {
    return offers(ref);
  }
}

String _$offersHash() => r'f0b2de3b37a8e57d4cafb43197790327fe48f273';

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

String _$myOffersHash() => r'b55f1105e2e383ea8138098d1b325b608a6c60e5';
