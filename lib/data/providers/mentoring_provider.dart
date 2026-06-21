import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/mentoring_module_model.dart';
import '../models/mentoring_progress_model.dart';
import '../services/mentoring_service.dart';

part 'mentoring_provider.g.dart';

@riverpod
Future<List<MentoringModule>> mentoringModules(Ref ref) async {
  final mentoringService = ref.watch(mentoringServiceProvider);
  return await mentoringService.getModules();
}

@riverpod
class MentoringProgressState extends _$MentoringProgressState {
  @override
  FutureOr<MentoringProgress> build() async {
    final service = ref.watch(mentoringServiceProvider);
    return await service.getProgress();
  }

  Future<void> completeModule(String moduleId) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(mentoringServiceProvider);
      final updatedProgress = await service.completeModule(moduleId);
      state = AsyncValue.data(updatedProgress);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
