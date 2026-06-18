import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_relevo/data/network/dio_client.dart';
import 'package:flutter_relevo/screens/chat_room_screen.dart';
import 'package:flutter_relevo/screens/notifications_inbox_screen.dart';

// Clave global para navegación directa desde fuera del árbol de widgets (Callbacks de FCM)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService(ref.read(dioProvider));
});

class PushNotificationService {
  final Dio _dio;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  bool _initialized = false;
  String? _lastToken;

  PushNotificationService(this._dio);

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 1. Inicializar Notificaciones Locales (para primer plano)
      const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettingsDarwin = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          final payload = details.payload;
          if (payload != null && payload.isNotEmpty) {
            _handleNotificationClick(payload);
          }
        },
      );

      // Crear canal de notificaciones en Android
      final androidImplementation = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        const channel = AndroidNotificationChannel(
          'high_importance_channel',
          'Notificaciones de Relevo',
          description: 'Canal usado para notificaciones importantes del chat.',
          importance: Importance.max,
        );
        await androidImplementation.createNotificationChannel(channel);
      }

      // 2. Solicitar permisos de FCM
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // 3. Obtener el token de FCM (silenciar error si falla en simulador sin APNs)
        try {
          final token = await messaging.getToken();
          if (token != null) {
            _lastToken = token;
            await _registerToken(token);
          }
        } catch (tokenError) {
          print('*** Advertencia: No se pudo obtener el token de FCM (esperado en simuladores iOS sin APNs configurado): $tokenError');
        }

        // Escuchar refrescos del token
        messaging.onTokenRefresh.listen((newToken) {
          _lastToken = newToken;
          _registerToken(newToken);
        }).onError((err) {
          print('*** Advertencia: Error al refrescar token FCM: $err');
        });

        // 4. Mensajes en primer plano
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          _showForegroundNotification(message);
        });

        // 5. Mensajes abiertos en segundo plano
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          _handleRemoteMessageClick(message);
        });

        // 6. Mensaje con el que arrancó la app desde cerrado
        final initialMessage = await messaging.getInitialMessage();
        if (initialMessage != null) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            _handleRemoteMessageClick(initialMessage);
          });
        }

        _initialized = true;
      }
    } catch (e) {
      print('*** Error al inicializar FCM: $e');
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      await _dio.post('/usuarios/fcm-token', data: {'token': token});
      print('*** FCM Token registrado en el servidor: $token');
    } catch (e) {
      print('*** Error al registrar FCM token en el servidor: $e');
    }
  }

  Future<void> cleanup() async {
    if (_lastToken != null) {
      try {
        await _dio.delete('/usuarios/fcm-token/$_lastToken');
        print('*** FCM Token eliminado del servidor: $_lastToken');
      } catch (e) {
        print('*** Error al eliminar FCM token del servidor: $e');
      }
    }

    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      print('*** Error al invalidar token FCM local: $e');
    }

    _lastToken = null;
    _initialized = false;
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'Notificaciones de Relevo',
            channelDescription: 'Canal usado para notificaciones importantes del chat.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(data),
      );
    }
  }

  void _handleRemoteMessageClick(RemoteMessage message) {
    _handleNotificationClick(jsonEncode(message.data));
  }

  void _handleNotificationClick(String payloadJson) {
    try {
      final Map<String, dynamic> data = jsonDecode(payloadJson);
      
      // Intentar extraer el chatId de la raíz de data o de metadata
      final chatId = data['chatId'] ?? data['metadata']?['chatId'];

      if (chatId != null && chatId.toString().isNotEmpty) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(chatId: chatId.toString()),
          ),
        );
      } else {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const NotificationsInboxScreen(),
          ),
        );
      }
    } catch (e) {
      print('*** Error al manejar el click de notificación: $e');
    }
  }
}
