import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_relevo/data/models/chat_model.dart';
import 'package:flutter_relevo/data/models/message_model.dart';
import 'package:flutter_relevo/data/services/chat_service.dart';
import 'package:flutter_relevo/data/services/socket_service.dart';
import 'package:flutter_relevo/data/providers/auth_provider.dart';
import 'package:flutter_relevo/data/services/push_notification_service.dart';

part 'chat_providers.g.dart';

@Riverpod(keepAlive: true)
void socketConnectionManager(Ref ref) {
  final authState = ref.watch(authProvider);
  final socketService = ref.read(socketServiceProvider);

  authState.when(
    data: (user) {
      if (user != null) {
        const storage = FlutterSecureStorage();
        storage.read(key: 'access_token').then((token) {
          if (token != null) {
            socketService.connect(token);
          }
        });
      } else {
        socketService.disconnect();
      }
    },
    error: (_, __) => socketService.disconnect(),
    loading: () {},
  );
}

@riverpod
class ChatsList extends _$ChatsList {
  StreamSubscription? _notificationSubscription;
  StreamSubscription? _messageSubscription;

  @override
  FutureOr<List<Chat>> build() async {
    // Escucha el socketManager para asegurar la conexión activa
    ref.watch(socketConnectionManagerProvider);

    final service = ref.read(chatServiceProvider);
    final socketService = ref.read(socketServiceProvider);
    final currentUser = ref.watch(authProvider).value;
    if (currentUser == null) return [];

    final chats = await service.getMyChats();

    _notificationSubscription?.cancel();
    _notificationSubscription = socketService.onChatNotification.listen((data) {
      final chatId = data['chatId'] as String?;
      final lastMsgJson = data['lastMessage'] as Map<String, dynamic>? ?? data['message'] as Map<String, dynamic>?;
      final unreadCount = data['unreadCount'] as int?;

      if (chatId != null && lastMsgJson != null && state.hasValue) {
        final currentChats = List<Chat>.from(state.value!);
        final index = currentChats.indexWhere((c) => c.id == chatId);

        final senderJson = lastMsgJson['sender'];
        final String senderId = lastMsgJson['senderId'] ?? 
            (senderJson is Map ? (senderJson['_id'] ?? senderJson['id'] ?? '') : (senderJson ?? ''));

        final lastMessage = ChatLastMessage(
          content: lastMsgJson['content'] ?? '',
          senderId: senderId,
          sentAt: lastMsgJson['sentAt'] != null
              ? DateTime.parse(lastMsgJson['sentAt'])
              : (lastMsgJson['createdAt'] != null ? DateTime.parse(lastMsgJson['createdAt']) : DateTime.now()),
        );

        if (index != -1) {
          final existingChat = currentChats[index];
          final isOwner = currentUser?.id == existingChat.owner.id;

          final isMe = senderId == currentUser?.id;
          final newUnreadOwner = isOwner && !isMe ? (unreadCount ?? (existingChat.unreadOwner + 1)) : existingChat.unreadOwner;
          final newUnreadInterested = !isOwner && !isMe ? (unreadCount ?? (existingChat.unreadInterested + 1)) : existingChat.unreadInterested;

          final updatedChat = Chat(
            id: existingChat.id,
            oferta: existingChat.oferta,
            owner: existingChat.owner,
            interested: existingChat.interested,
            lastMessage: lastMessage,
            unreadOwner: newUnreadOwner,
            unreadInterested: newUnreadInterested,
            isReadOnly: existingChat.isReadOnly,
            status: existingChat.status,
            closedByOwner: existingChat.closedByOwner,
            closedByInterested: existingChat.closedByInterested,
            closedAt: existingChat.closedAt,
            createdAt: existingChat.createdAt,
            updatedAt: lastMessage.sentAt,
          );

          currentChats.removeAt(index);
          currentChats.insert(0, updatedChat);
          state = AsyncValue.data(currentChats);
        } else {
          // Si no está en el listado, recargamos la lista completa para traer el nuevo chat
          ref.invalidateSelf();
        }
      }
    });

    _messageSubscription?.cancel();
    _messageSubscription = socketService.onMessageReceived.listen((message) {
      if (state.hasValue) {
        final currentChats = List<Chat>.from(state.value!);
        final index = currentChats.indexWhere((c) => c.id == message.chatId);

        final lastMessage = ChatLastMessage(
          content: message.content.isNotEmpty ? message.content : (message.messageType == 'image' ? '[Imatge]' : message.messageType == 'audio' ? '[Nota de veu]' : '[Fitxer]'),
          senderId: message.sender.id,
          sentAt: message.createdAt ?? DateTime.now(),
        );

        if (index != -1) {
          final existingChat = currentChats[index];
          final isOwner = currentUser?.id == existingChat.owner.id;

          // Si el remitente del mensaje no soy yo, incrementamos el contador de no leídos correspondientes
          final isMe = message.sender.id == currentUser?.id;
          final newUnreadOwner = isOwner && !isMe ? existingChat.unreadOwner + 1 : existingChat.unreadOwner;
          final newUnreadInterested = !isOwner && !isMe ? existingChat.unreadInterested + 1 : existingChat.unreadInterested;

          final updatedChat = Chat(
            id: existingChat.id,
            oferta: existingChat.oferta,
            owner: existingChat.owner,
            interested: existingChat.interested,
            lastMessage: lastMessage,
            unreadOwner: newUnreadOwner,
            unreadInterested: newUnreadInterested,
            isReadOnly: existingChat.isReadOnly,
            status: existingChat.status,
            closedByOwner: existingChat.closedByOwner,
            closedByInterested: existingChat.closedByInterested,
            closedAt: existingChat.closedAt,
            createdAt: existingChat.createdAt,
            updatedAt: lastMessage.sentAt,
          );

          currentChats.removeAt(index);
          currentChats.insert(0, updatedChat);
          state = AsyncValue.data(currentChats);
        } else {
          // Si no está en el listado, recargamos la lista completa para traer el nuevo chat
          ref.invalidateSelf();
        }
      }
    });

    ref.onDispose(() {
      _notificationSubscription?.cancel();
      _messageSubscription?.cancel();
    });

    // Ordenamos por fecha del último mensaje o updatedAt
    chats.sort((a, b) {
      final timeA = a.lastMessage?.sentAt ?? a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final timeB = b.lastMessage?.sentAt ?? b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return timeB.compareTo(timeA);
    });

    return chats;
  }

  Future<void> updateChatStatusInList(String chatId, String status) async {
    if (!state.hasValue) return;
    try {
      final service = ref.read(chatServiceProvider);
      final updatedChat = await service.updateChatStatus(chatId, status);
      
      final currentChats = List<Chat>.from(state.value!);
      final index = currentChats.indexWhere((c) => c.id == chatId);
      if (index != -1) {
        currentChats[index] = updatedChat;
        state = AsyncValue.data(currentChats);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void markChatAsReadLocally(String chatId) {
    if (!state.hasValue) return;
    final currentUser = ref.read(authProvider).value;
    final currentChats = List<Chat>.from(state.value!);
    final index = currentChats.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      final existingChat = currentChats[index];
      final isOwner = currentUser?.id == existingChat.owner.id;
      final updatedChat = Chat(
        id: existingChat.id,
        oferta: existingChat.oferta,
        owner: existingChat.owner,
        interested: existingChat.interested,
        lastMessage: existingChat.lastMessage,
        unreadOwner: isOwner ? 0 : existingChat.unreadOwner,
        unreadInterested: !isOwner ? 0 : existingChat.unreadInterested,
        isReadOnly: existingChat.isReadOnly,
        status: existingChat.status,
        closedByOwner: existingChat.closedByOwner,
        closedByInterested: existingChat.closedByInterested,
        closedAt: existingChat.closedAt,
        createdAt: existingChat.createdAt,
        updatedAt: existingChat.updatedAt,
      );
      currentChats[index] = updatedChat;
      state = AsyncValue.data(currentChats);
    }
  }

  void updateLastMessageInList(Message message) {
    if (!state.hasValue) return;
    final currentUser = ref.read(authProvider).value;
    final currentChats = List<Chat>.from(state.value!);
    final index = currentChats.indexWhere((c) => c.id == message.chatId);

    final lastMessage = ChatLastMessage(
      content: message.content.isNotEmpty
          ? message.content
          : (message.messageType == 'image'
              ? '[Imatge]'
              : message.messageType == 'audio'
                  ? '[Nota de veu]'
                  : '[Fitxer]'),
      senderId: message.sender.id,
      sentAt: message.createdAt ?? DateTime.now(),
    );

    if (index != -1) {
      final existingChat = currentChats[index];
      final isOwner = currentUser?.id == existingChat.owner.id;

      final isMe = message.sender.id == currentUser?.id;
      final newUnreadOwner = isOwner && !isMe ? existingChat.unreadOwner + 1 : existingChat.unreadOwner;
      final newUnreadInterested = !isOwner && !isMe ? existingChat.unreadInterested + 1 : existingChat.unreadInterested;

      final updatedChat = Chat(
        id: existingChat.id,
        oferta: existingChat.oferta,
        owner: existingChat.owner,
        interested: existingChat.interested,
        lastMessage: lastMessage,
        unreadOwner: newUnreadOwner,
        unreadInterested: newUnreadInterested,
        isReadOnly: existingChat.isReadOnly,
        status: existingChat.status,
        closedByOwner: existingChat.closedByOwner,
        closedByInterested: existingChat.closedByInterested,
        closedAt: existingChat.closedAt,
        createdAt: existingChat.createdAt,
        updatedAt: lastMessage.sentAt,
      );

      currentChats.removeAt(index);
      currentChats.insert(0, updatedChat);
      state = AsyncValue.data(currentChats);
    } else {
      ref.invalidateSelf();
    }
  }
}

@riverpod
class ChatRoomMessages extends _$ChatRoomMessages {
  StreamSubscription? _messageSubscription;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  FutureOr<List<Message>> build(String chatId) async {
    // Escucha el socketManager para asegurar la conexión activa
    ref.watch(socketConnectionManagerProvider);

    final service = ref.read(chatServiceProvider);
    final socketService = ref.read(socketServiceProvider);

    final messages = await service.getMessages(chatId, limit: 30);
    final reversedMessages = messages.reversed.toList();
    _hasMore = messages.length >= 30;

    // Conectarse a la sala de chat
    socketService.joinChat(chatId, onJoinAck: (isOnline) {
      ref.read(chatRoomPresenceProvider(chatId).notifier).setPresence(isOnline);
    });
    
    // Marcar como leído
    socketService.markRead(chatId);

    // Escuchar nuevos mensajes recibidos por el socket
    _messageSubscription?.cancel();
    _messageSubscription = socketService.onMessageReceived.listen((message) {
      if (message.chatId == chatId && state.hasValue) {
        final currentMessages = List<Message>.from(state.value!);
        
        // Evitamos duplicar si el mensaje ya fue insertado localmente por send_message ACK
        if (!currentMessages.any((m) => m.id == message.id)) {
          currentMessages.insert(0, message);
          state = AsyncValue.data(currentMessages);

          // Le indicamos al servidor que lo hemos leído
          socketService.markRead(chatId);
          // Actualizamos la lista de chats en segundo plano
          ref.read(chatsListProvider.notifier).updateLastMessageInList(message);
          ref.read(chatsListProvider.notifier).markChatAsReadLocally(chatId);
        }
      }
    });

    ref.onDispose(() {
      socketService.leaveChat(chatId);
      _messageSubscription?.cancel();
    });

    return reversedMessages;
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingMore || !_hasMore || !state.hasValue) return;

    _isLoadingMore = true;
    try {
      final service = ref.read(chatServiceProvider);
      final currentMessages = state.value!;
      
      String? beforeTimestamp;
      if (currentMessages.isNotEmpty) {
        beforeTimestamp = currentMessages.last.createdAt?.toIso8601String();
      }

      if (beforeTimestamp != null) {
        final olderMessages = await service.getMessages(chatId, before: beforeTimestamp, limit: 30);
        _hasMore = olderMessages.length >= 30;
        
        state = AsyncValue.data([...currentMessages, ...olderMessages.reversed]);
      }
    } catch (e, st) {
      // Ignorar o propagar error silenciosamente en paginación
    } finally {
      _isLoadingMore = false;
    }
  }

  void addLocalMessage(Message message) {
    if (state.hasValue) {
      final current = List<Message>.from(state.value!);
      if (!current.any((m) => m.id == message.id)) {
        current.insert(0, message);
        state = AsyncValue.data(current);
        // Actualizamos la lista de chats en segundo plano
        ref.read(chatsListProvider.notifier).updateLastMessageInList(message);
      }
    }
  }
}

@riverpod
class ChatRoomTyping extends _$ChatRoomTyping {
  StreamSubscription? _startSub;
  StreamSubscription? _stopSub;

  @override
  bool build(String chatId) {
    final socketService = ref.read(socketServiceProvider);
    final currentUser = ref.watch(authProvider).value;

    _startSub?.cancel();
    _startSub = socketService.onTypingStart.listen((typingUserId) {
      if (typingUserId != currentUser?.id) {
        state = true;
      }
    });

    _stopSub?.cancel();
    _stopSub = socketService.onTypingStop.listen((typingUserId) {
      if (typingUserId != currentUser?.id) {
        state = false;
      }
    });

    ref.onDispose(() {
      _startSub?.cancel();
      _stopSub?.cancel();
    });

    return false;
  }
}

@riverpod
class ChatRoomPresence extends _$ChatRoomPresence {
  StreamSubscription? _onlineSub;
  StreamSubscription? _offlineSub;

  @override
  bool build(String chatId) {
    final socketService = ref.read(socketServiceProvider);
    final currentUser = ref.watch(authProvider).value;

    _onlineSub?.cancel();
    _onlineSub = socketService.onUserOnline.listen((userId) {
      if (userId != currentUser?.id) {
        state = true;
      }
    });

    _offlineSub?.cancel();
    _offlineSub = socketService.onUserOffline.listen((userId) {
      if (userId != currentUser?.id) {
        state = false;
      }
    });

    ref.onDispose(() {
      _onlineSub?.cancel();
      _offlineSub?.cancel();
    });

    return false;
  }

  void setPresence(bool isOnline) {
    state = isOnline;
  }
}

@Riverpod(keepAlive: true)
void notificationManager(Ref ref) {
  final authState = ref.watch(authProvider);
  final pushService = ref.read(pushNotificationServiceProvider);

  authState.when(
    data: (user) {
      if (user != null) {
        pushService.initialize();
      } else {
        pushService.cleanup();
      }
    },
    error: (_, __) => pushService.cleanup(),
    loading: () {},
  );
}

@riverpod
int unreadChatsCount(Ref ref) {
  final chatsAsync = ref.watch(chatsListProvider);
  final currentUser = ref.watch(authProvider).value;

  if (currentUser == null) return 0;

  return chatsAsync.maybeWhen(
    data: (chats) {
      return chats.fold<int>(0, (sum, chat) {
        final isOwner = currentUser.id == chat.owner.id;
        final unreadCount = isOwner ? chat.unreadOwner : chat.unreadInterested;
        return sum + unreadCount;
      });
    },
    orElse: () => 0,
  );
}
