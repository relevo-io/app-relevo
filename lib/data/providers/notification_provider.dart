import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../services/socket_service.dart';
import 'auth_provider.dart';
import 'chat_providers.dart';

part 'notification_provider.g.dart';

@riverpod
class NotificationsState extends _$NotificationsState {
  @override
  FutureOr<List<NotificationModel>> build() async {
    final currentUser = ref.watch(authProvider).value;
    if (currentUser == null) return [];

    // Garantizar que la conexión del socket esté activa
    ref.watch(socketConnectionManagerProvider);

    final service = ref.watch(notificationServiceProvider);
    final socketService = ref.read(socketServiceProvider);

    final notifications = await service.getNotifications();

    // Escuchar notificaciones entrantes en tiempo real
    final subscription = socketService.onNewNotification.listen((notification) {
      if (state.hasValue) {
        final current = List<NotificationModel>.from(state.value!);
        if (!current.any((n) => n.id == notification.id)) {
          current.insert(0, notification);
          state = AsyncValue.data(current);
        }
      }
    });

    ref.onDispose(() {
      subscription.cancel();
    });

    return notifications;
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.markAsRead(notificationId);
      ref.invalidateSelf();
      await future;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.markAllAsRead();
      ref.invalidateSelf();
      await future;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.deleteNotification(notificationId);
      ref.invalidateSelf();
      await future;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.clearAllNotifications();
      ref.invalidateSelf();
      await future;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void markChatNotificationsAsReadLocally(String chatId) {
    if (!state.hasValue) return;
    final current = List<NotificationModel>.from(state.value!);
    bool changed = false;
    for (int i = 0; i < current.length; i++) {
      final n = current[i];
      if (n.type == 'chat' && n.data['chatId'] == chatId && !n.isRead) {
        current[i] = NotificationModel(
          id: n.id,
          userId: n.userId,
          title: n.title,
          body: n.body,
          type: n.type,
          data: n.data,
          isRead: true,
          createdAt: n.createdAt,
        );
        changed = true;
      }
    }
    if (changed) {
      state = AsyncValue.data(current);
    }
  }

  void markSolicitudNotificationsAsRead(String solicitudId) {
    if (!state.hasValue) return;
    final current = List<NotificationModel>.from(state.value!);
    bool changed = false;
    for (int i = 0; i < current.length; i++) {
      final n = current[i];
      if ((n.type == 'solicitud' || n.type == 'cv_analysis') &&
          n.data['solicitudId'] == solicitudId &&
          !n.isRead) {
        current[i] = NotificationModel(
          id: n.id,
          userId: n.userId,
          title: n.title,
          body: n.body,
          type: n.type,
          data: n.data,
          isRead: true,
          createdAt: n.createdAt,
        );
        changed = true;
        // Notificar al backend de forma asíncrona
        ref.read(notificationServiceProvider).markAsRead(n.id);
      }
    }
    if (changed) {
      state = AsyncValue.data(current);
    }
  }

  void markOfferNotificationsAsRead(String offerId) {
    if (!state.hasValue) return;
    final current = List<NotificationModel>.from(state.value!);
    bool changed = false;
    for (int i = 0; i < current.length; i++) {
      final n = current[i];
      if (n.type == 'alerta' && n.data['offerId'] == offerId && !n.isRead) {
        current[i] = NotificationModel(
          id: n.id,
          userId: n.userId,
          title: n.title,
          body: n.body,
          type: n.type,
          data: n.data,
          isRead: true,
          createdAt: n.createdAt,
        );
        changed = true;
        // Notificar al backend de forma asíncrona
        ref.read(notificationServiceProvider).markAsRead(n.id);
      }
    }
    if (changed) {
      state = AsyncValue.data(current);
    }
  }
}

@riverpod
int unreadNotificationsCount(Ref ref) {
  final asyncNotifications = ref.watch(notificationsStateProvider);
  return asyncNotifications.maybeWhen(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
}
