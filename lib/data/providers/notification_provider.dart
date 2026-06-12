import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

part 'notification_provider.g.dart';

@riverpod
class NotificationsState extends _$NotificationsState {
  @override
  FutureOr<List<NotificationModel>> build() async {
    final service = ref.watch(notificationServiceProvider);
    return await service.getNotifications();
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
}

@riverpod
int unreadNotificationsCount(Ref ref) {
  final asyncNotifications = ref.watch(notificationsStateProvider);
  return asyncNotifications.maybeWhen(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
}
