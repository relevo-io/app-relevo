import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_relevo/data/providers/chat_providers.dart';
import 'package:flutter_relevo/data/providers/auth_provider.dart';
import 'package:flutter_relevo/data/models/chat_model.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchar el socket connection manager para asegurar conectividad
    ref.watch(socketConnectionManagerProvider);

    final chatsAsync = ref.watch(chatsListProvider);
    final currentUser = ref.watch(authProvider).value;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    // Traducciones locales manuales según el idioma activo
    final String titleText = locale == 'ca'
        ? 'Contacte Directe'
        : locale == 'es'
        ? 'Contacto Directo'
        : 'Direct Contact';

    final String emptyText = locale == 'ca'
        ? 'No tens cap conversa activa encara.'
        : locale == 'es'
        ? 'No tienes ninguna conversación activa todavía.'
        : 'You do not have any active conversations yet.';

    final String pendingText = locale == 'ca'
        ? 'Pendent d\'aprovació'
        : locale == 'es'
        ? 'Pendiente de aprobación'
        : 'Pending approval';

    final String rejectedText = locale == 'ca'
        ? 'Rebutjat'
        : locale == 'es'
        ? 'Rechazado'
        : 'Rejected';

    final String acceptButtonText = locale == 'ca' ? 'Acceptar' : locale == 'es' ? 'Aceptar' : 'Accept';
    final String rejectButtonText = locale == 'ca' ? 'Rebutjar' : locale == 'es' ? 'Rechazar' : 'Reject';

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20.0),
        child: chatsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              err.toString(),
              style: TextStyle(color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (chats) {
          if (chats.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 64,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      emptyText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            itemCount: chats.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final chat = chats[index];
              final isOwner = currentUser?.id == chat.owner.id;
              final otherUser = isOwner ? chat.interested : chat.owner;
              final unreadCount = isOwner ? chat.unreadOwner : chat.unreadInterested;
              final isUnread = unreadCount > 0;

              // Obtener iniciales
              final initials = otherUser.fullName.isNotEmpty
                  ? otherUser.fullName.split(' ').map((e) => e.isEmpty ? '' : e[0]).take(2).join().toUpperCase()
                  : '?';

              // Formatear hora de último mensaje
              final lastMsgTime = chat.lastMessage?.sentAt ?? chat.updatedAt;
              final timeAgoStr = lastMsgTime != null ? timeago.format(lastMsgTime, locale: locale) : '';

              // Contenido del último mensaje
              final String lastMsgContent;
              if (chat.lastMessage != null) {
                lastMsgContent = chat.lastMessage!.content;
              } else {
                lastMsgContent = locale == 'ca'
                    ? 'Conversa iniciada'
                    : locale == 'es'
                    ? 'Conversación iniciada'
                    : 'Conversation started';
              }

              final bool isPending = chat.status == 'PENDING_APPROVAL';
              final bool isRejected = chat.status == 'REJECTED';

              return Container(
                decoration: BoxDecoration(
                  color: isUnread
                      ? theme.colorScheme.primary.withValues(alpha: 0.04)
                      : theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUnread
                        ? theme.colorScheme.primary.withValues(alpha: 0.15)
                        : theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoomScreen(chatId: chat.id),
                        ),
                      ).then((_) {
                        ref.invalidate(chatsListProvider);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: isUnread
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                                child: Text(
                                  initials,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isUnread ? Colors.white : theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            otherUser.fullName,
                                            style: GoogleFonts.inter(
                                              fontWeight: isUnread ? FontWeight.w800 : FontWeight.bold,
                                              fontSize: 15,
                                              color: theme.colorScheme.onSurface,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (timeAgoStr.isNotEmpty)
                                          Text(
                                            timeAgoStr,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${chat.oferta.sector} • ${chat.oferta.region}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.secondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      lastMsgContent,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                                        color: isUnread
                                            ? theme.colorScheme.onSurface
                                            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Estado de Aprobación
                          if (isPending || isRejected) ...[
                            const SizedBox(height: 12),
                            const Divider(height: 1, thickness: 0.5),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isPending
                                        ? Colors.amber.withValues(alpha: 0.15)
                                        : Colors.red.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    isPending ? pendingText : rejectedText,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isPending ? Colors.amber[800] : Colors.red[800],
                                    ),
                                  ),
                                ),
                                if (isPending && isOwner)
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          ref.read(chatsListProvider.notifier).updateChatStatusInList(
                                                chat.id,
                                                'REJECTED',
                                              );
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: theme.colorScheme.error,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          rejectButtonText,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          ref.read(chatsListProvider.notifier).updateChatStatusInList(
                                                chat.id,
                                                'APPROVED',
                                              );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: theme.colorScheme.secondary,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          acceptButtonText,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
}
