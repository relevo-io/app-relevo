import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/solicitud_model.dart';
import '../services/solicitud_service.dart';
import '../services/socket_service.dart';

part 'solicitud_provider.g.dart';

@riverpod
class ReceivedRequests extends _$ReceivedRequests {
  @override
  FutureOr<List<Solicitud>> build() async {
    final service = ref.watch(solicitudServiceProvider);
    
    // Escucha notificaciones en tiempo real para invalidar/actualizar la lista de solicitudes recibidas
    final socketService = ref.watch(socketServiceProvider);
    final subscription = socketService.onNewNotification.listen((notification) {
      if (notification.type == 'solicitud') {
        ref.invalidateSelf();
      }
    });

    ref.onDispose(() {
      subscription.cancel();
    });

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

  Future<Solicitud> analizarCv(String id) async {
    final service = ref.read(solicitudServiceProvider);
    final updated = await service.analizarCvConIa(id);
    ref.invalidateSelf();
    return updated;
  }
}

@riverpod
class SentRequests extends _$SentRequests {
  @override
  FutureOr<List<Solicitud>> build() async {
    final service = ref.watch(solicitudServiceProvider);

    // Escucha notificaciones en tiempo real para invalidar/actualizar la lista de solicitudes enviadas
    final socketService = ref.watch(socketServiceProvider);
    final subscription = socketService.onNewNotification.listen((notification) {
      if (notification.type == 'solicitud') {
        ref.invalidateSelf();
      }
    });

    ref.onDispose(() {
      subscription.cancel();
    });

    return await service.getSentRequests();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
