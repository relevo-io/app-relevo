import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_relevo/data/network/dio_client.dart';
import 'package:flutter_relevo/data/models/chat_model.dart';
import 'package:flutter_relevo/data/models/message_model.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService(ref.read(dioProvider));
});

class ChatService {
  final Dio _dio;

  ChatService(this._dio);

  Future<List<Chat>> getMyChats() async {
    try {
      final response = await _dio.get('/chats');
      final List<dynamic> data = response.data;
      return data.map((json) => Chat.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener chats',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Chat> getOrCreateChat(String ofertaId, {String? interestedId}) async {
    try {
      final response = await _dio.post(
        '/chats',
        data: {
          'ofertaId': ofertaId,
          if (interestedId != null) 'interestedId': interestedId,
        },
      );
      return Chat.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al crear o recuperar chat',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<List<Message>> getMessages(String chatId, {String? before, int limit = 30}) async {
    try {
      final response = await _dio.get(
        '/chats/$chatId/messages',
        queryParameters: {
          'limit': limit,
          if (before != null) 'before': before,
        },
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Message.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener mensajes del chat',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> markChatAsRead(String chatId) async {
    try {
      await _dio.patch('/chats/$chatId/read');
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al marcar chat como leído',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Chat> updateChatStatus(String chatId, String status) async {
    try {
      final response = await _dio.patch(
        '/chats/$chatId/status',
        data: {'status': status},
      );
      return Chat.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al cambiar estado del chat',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getPresignedUploadUrl(String filename, String mimeType) async {
    try {
      final response = await _dio.get(
        '/storage/chat-presigned-url',
        queryParameters: {
          'filename': filename,
          'mimeType': mimeType,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener URL firmada de S3',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> uploadFileToS3(String uploadUrl, List<int> fileBytes, String mimeType) async {
    try {
      // Usamos una instancia limpia de Dio para evitar adjuntar la cabecera Authorization (Bearer JWT)
      // que causaría que S3 rechazara la firma pre-generada.
      final cleanDio = Dio();
      await cleanDio.put(
        uploadUrl,
        data: fileBytes,
        options: Options(
          headers: {
            'Content-Type': mimeType,
            'Content-Length': fileBytes.length,
          },
        ),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Error al subir archivo a S3 (Código ${e.response?.statusCode}): ${e.response?.statusMessage}',
        );
      }
      throw Exception('Error de conexión durante la subida a S3: ${e.message}');
    }
  }
}
