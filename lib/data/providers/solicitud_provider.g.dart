// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solicitud_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReceivedRequests)
final receivedRequestsProvider = ReceivedRequestsProvider._();

final class ReceivedRequestsProvider
    extends $AsyncNotifierProvider<ReceivedRequests, List<Solicitud>> {
  ReceivedRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receivedRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receivedRequestsHash();

  @$internal
  @override
  ReceivedRequests create() => ReceivedRequests();
}

String _$receivedRequestsHash() => r'4aa6ca0e45cc7848423d08130653186a4b454bb8';

abstract class _$ReceivedRequests extends $AsyncNotifier<List<Solicitud>> {
  FutureOr<List<Solicitud>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Solicitud>>, List<Solicitud>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Solicitud>>, List<Solicitud>>,
              AsyncValue<List<Solicitud>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SentRequests)
final sentRequestsProvider = SentRequestsProvider._();

final class SentRequestsProvider
    extends $AsyncNotifierProvider<SentRequests, List<Solicitud>> {
  SentRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sentRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sentRequestsHash();

  @$internal
  @override
  SentRequests create() => SentRequests();
}

String _$sentRequestsHash() => r'27bcc9ea777b35105aeecad8443044a92fe480d1';

abstract class _$SentRequests extends $AsyncNotifier<List<Solicitud>> {
  FutureOr<List<Solicitud>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Solicitud>>, List<Solicitud>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Solicitud>>, List<Solicitud>>,
              AsyncValue<List<Solicitud>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
