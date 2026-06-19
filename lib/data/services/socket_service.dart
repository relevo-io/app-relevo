import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_relevo/data/network/dio_client.dart';
import 'package:flutter_relevo/data/models/message_model.dart';

final socketServiceProvider = Provider<SocketService>((ref) {
  // Obtenemos la URL base de Dio para deducir la URL del Socket
  final dio = ref.read(dioProvider);
  final baseUrl = dio.options.baseUrl; // Por ejemplo "http://localhost:4000/api"
  final socketUrl = baseUrl.replaceAll('/api', ''); // Por ejemplo "http://localhost:4000"
  
  return SocketService(socketUrl);
});

class SocketService {
  final String _socketUrl;
  IO.Socket? _socket;

  // StreamControllers para exponer los eventos entrantes del WebSocket
  final _messageController = StreamController<Message>.broadcast();
  final _chatNotificationController = StreamController<Map<String, dynamic>>.broadcast();
  final _typingStartController = StreamController<String>.broadcast();
  final _typingStopController = StreamController<String>.broadcast();
  final _userOnlineController = StreamController<String>.broadcast();
  final _userOfflineController = StreamController<String>.broadcast();
  final _connectionStateController = StreamController<bool>.broadcast();

  SocketService(this._socketUrl);

  // Getters de los Streams
  Stream<Message> get onMessageReceived => _messageController.stream;
  Stream<Map<String, dynamic>> get onChatNotification => _chatNotificationController.stream;
  Stream<String> get onTypingStart => _typingStartController.stream;
  Stream<String> get onTypingStop => _typingStopController.stream;
  Stream<String> get onUserOnline => _userOnlineController.stream;
  Stream<String> get onUserOffline => _userOfflineController.stream;
  Stream<bool> get onConnectionStateChanged => _connectionStateController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect(String token) {
    if (_socket != null) {
      disconnect();
    }

    _socket = IO.io(
      _socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': 'Bearer $token'})
          .enableForceNew()
          .build(),
    );

    _socket!.onConnect((_) {
      _connectionStateController.add(true);
    });

    _socket!.onDisconnect((_) {
      _connectionStateController.add(false);
    });

    _socket!.onConnectError((err) {
      _connectionStateController.add(false);
    });

    // Registrar manejadores de eventos entrantes
    _socket!.on('new_message', (data) {
      try {
        final message = Message.fromJson(data);
        _messageController.add(message);
      } catch (e) {
        // Ignorar errores de parsing
      }
    });

    _socket!.on('chat_notification', (data) {
      if (data is Map<String, dynamic>) {
        _chatNotificationController.add(data);
      }
    });

    _socket!.on('typing_start', (data) {
      if (data is Map && data['userId'] != null) {
        _typingStartController.add(data['userId'].toString());
      }
    });

    _socket!.on('typing_stop', (data) {
      if (data is Map && data['userId'] != null) {
        _typingStopController.add(data['userId'].toString());
      }
    });

    _socket!.on('user_online', (data) {
      if (data is Map && data['userId'] != null) {
        _userOnlineController.add(data['userId'].toString());
      }
    });

    _socket!.on('user_offline', (data) {
      if (data is Map && data['userId'] != null) {
        _userOfflineController.add(data['userId'].toString());
      }
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _connectionStateController.add(false);
  }

  // --- Emisión de Eventos ---

  void joinChat(String chatId, {Function(bool isOnline)? onJoinAck}) {
    if (_socket != null && _socket!.connected) {
      if (onJoinAck != null) {
        _socket!.emitWithAck('join_chat', {'chatId': chatId}, ack: (data) {
          if (data is Map) {
            final ok = data['ok'] ?? false;
            final isOnline = data['isOnline'] ?? false;
            if (ok) {
              onJoinAck(isOnline);
            }
          }
        });
      } else {
        _socket!.emit('join_chat', {'chatId': chatId});
      }
    }
  }

  void leaveChat(String chatId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('leave_chat', {'chatId': chatId});
    }
  }

  Future<Message> sendMessage(
    String chatId, {
    String? content,
    String messageType = 'text',
    String? s3Key,
    String? fileName,
    int? fileSize,
    String? mimeType,
  }) {
    final completer = Completer<Message>();

    if (_socket == null || !_socket!.connected) {
      completer.completeError(Exception('Socket no conectado'));
      return completer.future;
    }

    final payload = {
      'chatId': chatId,
      if (content != null) 'content': content,
      'messageType': messageType,
      if (s3Key != null) 's3Key': s3Key,
      if (fileName != null) 'fileName': fileName,
      if (fileSize != null) 'fileSize': fileSize,
      if (mimeType != null) 'mimeType': mimeType,
    };

    _socket!.emitWithAck('send_message', payload, ack: (data) {
      if (data is Map) {
        final ok = data['ok'] ?? false;
        if (ok && data['message'] != null) {
          try {
            final msg = Message.fromJson(data['message']);
            completer.complete(msg);
          } catch (e) {
            completer.completeError(Exception('Error al decodificar respuesta del mensaje: $e'));
          }
        } else {
          completer.completeError(Exception(data['error'] ?? 'Error desconocido al enviar mensaje'));
        }
      } else {
        completer.completeError(Exception('Respuesta inválida del servidor de WebSocket'));
      }
    });

    return completer.future;
  }

  void sendTypingStart(String chatId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('typing_start', {'chatId': chatId});
    }
  }

  void sendTypingStop(String chatId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('typing_stop', {'chatId': chatId});
    }
  }

  void markRead(String chatId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('mark_read', {'chatId': chatId});
    }
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _chatNotificationController.close();
    _typingStartController.close();
    _typingStopController.close();
    _userOnlineController.close();
    _userOfflineController.close();
    _connectionStateController.close();
  }
}
