import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/solicitud_model.dart';
import '../services/solicitud_service.dart';

part 'solicitud_provider.g.dart';

@riverpod
class ReceivedRequests extends _$ReceivedRequests {
  @override
  FutureOr<List<Solicitud>> build() async {
    final service = ref.watch(solicitudServiceProvider);
    return await service.getReceivedRequests();
  }

  Future<void> acceptRequest(String id) async {
    final service = ref.read(solicitudServiceProvider);
    await service.updateRequestStatus(id, 'ACCEPTED');
    ref.invalidateSelf();
  }

  Future<void> rejectRequest(String id) async {
    final service = ref.read(solicitudServiceProvider);
    await service.updateRequestStatus(id, 'REJECTED');
    ref.invalidateSelf();
  }
}

@riverpod
class SentRequests extends _$SentRequests {
  @override
  FutureOr<List<Solicitud>> build() async {
    final service = ref.watch(solicitudServiceProvider);
    return await service.getSentRequests();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
