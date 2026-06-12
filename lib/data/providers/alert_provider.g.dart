// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlertsState)
final alertsStateProvider = AlertsStateProvider._();

final class AlertsStateProvider
    extends $AsyncNotifierProvider<AlertsState, List<Alert>> {
  AlertsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertsStateHash();

  @$internal
  @override
  AlertsState create() => AlertsState();
}

String _$alertsStateHash() => r'c605df20decfb2a73d20db101a4055e526ff6cd1';

abstract class _$AlertsState extends $AsyncNotifier<List<Alert>> {
  FutureOr<List<Alert>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Alert>>, List<Alert>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Alert>>, List<Alert>>,
              AsyncValue<List<Alert>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
