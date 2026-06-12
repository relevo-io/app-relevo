// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentoring_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mentoringModules)
final mentoringModulesProvider = MentoringModulesProvider._();

final class MentoringModulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MentoringModule>>,
          List<MentoringModule>,
          FutureOr<List<MentoringModule>>
        >
    with
        $FutureModifier<List<MentoringModule>>,
        $FutureProvider<List<MentoringModule>> {
  MentoringModulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mentoringModulesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mentoringModulesHash();

  @$internal
  @override
  $FutureProviderElement<List<MentoringModule>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MentoringModule>> create(Ref ref) {
    return mentoringModules(ref);
  }
}

String _$mentoringModulesHash() => r'08d95645b9a3dbb5c34de8fd6d4a8e926bdff5d5';

@ProviderFor(MentoringProgressState)
final mentoringProgressStateProvider = MentoringProgressStateProvider._();

final class MentoringProgressStateProvider
    extends $AsyncNotifierProvider<MentoringProgressState, MentoringProgress> {
  MentoringProgressStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mentoringProgressStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mentoringProgressStateHash();

  @$internal
  @override
  MentoringProgressState create() => MentoringProgressState();
}

String _$mentoringProgressStateHash() =>
    r'fcf61df58cb5969de30dcc9de6851ef527819f0e';

abstract class _$MentoringProgressState
    extends $AsyncNotifier<MentoringProgress> {
  FutureOr<MentoringProgress> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<MentoringProgress>, MentoringProgress>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MentoringProgress>, MentoringProgress>,
              AsyncValue<MentoringProgress>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
