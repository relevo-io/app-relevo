import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/alert_model.dart';
import '../services/alert_service.dart';

part 'alert_provider.g.dart';

@riverpod
class AlertsState extends _$AlertsState {
  @override
  FutureOr<List<Alert>> build() async {
    final service = ref.watch(alertServiceProvider);
    return await service.getAlerts();
  }

  Future<void> createAlert(String revenueRange) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(alertServiceProvider);
      await service.createAlert(revenueRange);
      ref.invalidateSelf();
      await future;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteAlert(String alertId) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(alertServiceProvider);
      await service.deleteAlert(alertId);
      ref.invalidateSelf();
      await future;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
