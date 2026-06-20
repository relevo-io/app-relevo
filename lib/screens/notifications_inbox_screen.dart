import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../data/providers/notification_provider.dart';
import '../data/providers/navigation_providers.dart';
import '../data/services/solicitud_service.dart';
import '../data/services/offer_service.dart';
import '../l10n/app_localizations.dart';
import 'notification_preferences_screen.dart';
import 'chat_room_screen.dart';
import 'solicitud_details_screen.dart';
import 'offer_details_screen.dart';

import '../widgets/glassmorphic_app_bar.dart';

class NotificationsInboxScreen extends ConsumerWidget {
  const NotificationsInboxScreen({super.key});

  Future<void> _handleNotificationTap(
    BuildContext context,
    WidgetRef ref,
    notification,
  ) async {
    final theme = Theme.of(context);
    
    // Marcar como leído en local inmediatamente al pulsar
    if (!notification.isRead) {
      ref
          .read(notificationsStateProvider.notifier)
          .markAsRead(notification.id);
    }

    // Mostrar loader dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      if (notification.type == 'chat') {
        final chatId = notification.data['chatId'];
        if (chatId != null && chatId.isNotEmpty) {
          if (context.mounted) {
            Navigator.pop(context); // Cerrar loader
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoomScreen(chatId: chatId),
              ),
            );
          }
        } else {
          if (context.mounted) Navigator.pop(context);
        }
      } else if (notification.type == 'solicitud' ||
          notification.type == 'cv_analysis') {
        if (context.mounted) Navigator.pop(context); // Cerrar loader

        // Determinar si es una solicitud enviada (candidato) o recibida (propietario)
        // Las de estado ACCEPTED/REJECTED son para el candidato.
        int targetTab = 0; // 0 = Recibidas
        final statusMeta = notification.data['status'];
        if (notification.type == 'solicitud' &&
            (statusMeta == 'ACCEPTED' || statusMeta == 'REJECTED')) {
          targetTab = 1; // 1 = Enviadas
        }

        // Navegar a la pestaña "Solicitudes" (índice 2) y a la subpestaña correcta
        ref.read(mainNavigationIndexProvider.notifier).setIndex(2);
        ref.read(inboxActiveTabProvider.notifier).setTab(targetTab);

        // Volver a la pantalla principal
        if (context.mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      } else if (notification.type == 'alerta') {
        final offerId = notification.data['offerId'];
        if (offerId != null && offerId.isNotEmpty) {
          final service = ref.read(offerServiceProvider);
          final offerDetail = await service.getOfferById(offerId);
          if (context.mounted) {
            Navigator.pop(context); // Cerrar loader
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OfferDetailsScreen(offer: offerDetail),
              ),
            );
          }
        } else {
          if (context.mounted) Navigator.pop(context);
        }
      } else {
        if (context.mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Cerrar loader en caso de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStateProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    final topPadding = MediaQuery.of(context).padding.top + 68.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassmorphicAppBar(
        title: null,
        actions: [
          // Marcar todo como leído
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: l10n.notificationsMarkAllRead,
            onPressed: () async {
              try {
                await ref
                    .read(notificationsStateProvider.notifier)
                    .markAllAsRead();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: theme.colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
          ),
          // Vaciar historial
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: l10n.notificationsClearAll,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.notificationsClearAll),
                  content: Text(l10n.notificationsClearConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(l10n.notificationsCancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                      child: Text(l10n.notificationsDelete),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  await ref
                      .read(notificationsStateProvider.notifier)
                      .clearAllNotifications();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: theme.colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              }
            },
          ),
          // Ajustes / Preferencias
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.notificationPreferencesTitle,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPreferencesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.0, topPadding, 24.0, 16.0),
            child: Text(
              l10n.notificationsTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ),
            Expanded(
              child: notificationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    err.toString(),
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
                data: (notifications) {
                  final content = notifications.isEmpty
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 80.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_off_outlined,
                                    size: 64,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.notificationsEmpty,
                                    style: GoogleFonts.inter(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final isUnread = !notification.isRead;
                    final String titleText = notification.title.isNotEmpty
                        ? notification.title
                        : (notification.type == 'NUEVA_OFERTA'
                            ? l10n.notificationsNewOffer(notification.data['sector'] ?? '')
                            : notification.type);
                    final String bodyText = notification.body;

                    final timeAgoStr = notification.createdAt != null
                        ? timeago.format(notification.createdAt!, locale: locale)
                        : '';

                    return Dismissible(
                      key: Key(notification.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(l10n.notificationsDelete),
                            content: Text(l10n.notificationsDeleteConfirm),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(l10n.notificationsCancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.error,
                                ),
                                child: Text(l10n.notificationsDelete),
                              ),
                            ],
                          ),
                        );
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      onDismissed: (direction) async {
                        try {
                          await ref
                              .read(notificationsStateProvider.notifier)
                              .deleteNotification(notification.id);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: theme.colorScheme.error,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _handleNotificationTap(context, ref, notification),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isUnread
                                ? theme.colorScheme.primary.withValues(alpha: 0.08)
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isUnread
                                  ? theme.colorScheme.primary.withValues(alpha: 0.3)
                                  : theme.colorScheme.outline.withValues(alpha: 0.08),
                              width: isUnread ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isUnread
                                      ? theme.colorScheme.primary.withValues(alpha: 0.12)
                                      : theme.colorScheme.onSurface.withValues(alpha: 0.04),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: isUnread
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      titleText,
                                      style: GoogleFonts.inter(
                                        fontWeight: isUnread ? FontWeight.w900 : FontWeight.w500,
                                        fontSize: 14,
                                        color: isUnread
                                            ? theme.colorScheme.onSurface
                                            : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                      ),
                                    ),
                                    if (bodyText.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        bodyText,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                                          color: isUnread
                                              ? theme.colorScheme.onSurface.withValues(alpha: 0.85)
                                              : theme.colorScheme.onSurface.withValues(alpha: 0.55),
                                        ),
                                      ),
                                    ],
                                    if (timeAgoStr.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        timeAgoStr,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: theme.colorScheme.onSurface.withValues(
                                            alpha: isUnread ? 0.5 : 0.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isUnread)
                                Container(
                                  margin: const EdgeInsets.only(left: 8, top: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificationsStateProvider);
              try {
                await ref.read(notificationsStateProvider.future);
              } catch (_) {}
            },
            color: const Color(0xFF10B981),
            child: content,
          );
        },
      ),
    ),
  ],
),
    );
  }
}
