import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../data/providers/notification_provider.dart';
import '../l10n/app_localizations.dart';

class NotificationsInboxScreen extends ConsumerWidget {
  const NotificationsInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStateProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    notificationsAsync.whenData((notifications) {
      final unread = notifications.where((n) => !n.isRead).toList();
      if (unread.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (final notification in unread) {
            ref
                .read(notificationsStateProvider.notifier)
                .markAsRead(notification.id);
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        elevation: 0,
      ),
      body: notificationsAsync.when(
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
                    child: Text(
                      l10n.notificationsEmpty,
                      style: GoogleFonts.inter(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
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

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isUnread
                      ? theme.colorScheme.primary.withValues(alpha: 0.06)
                      : theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUnread
                        ? theme.colorScheme.primary.withValues(alpha: 0.2)
                        : theme.colorScheme.outline.withValues(alpha: 0.1),
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
                            : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: isUnread
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                              fontWeight:
                                  isUnread ? FontWeight.bold : FontWeight.w700,
                              fontSize: 14,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          if (bodyText.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              bodyText,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
                                    alpha: 0.4,
                                  )),
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
    );
  }
}
