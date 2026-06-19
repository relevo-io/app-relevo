import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../models/solicitud_model.dart';

final solicitudServiceProvider = Provider<SolicitudService>((ref) {
  return SolicitudService(ref.read(dioProvider));
});

class SolicitudService {
  final Dio _dio;

  SolicitudService(this._dio);

  Future<List<Solicitud>> getReceivedRequests() async {
    try {
      final response = await _dio.get('/solicitudes/me/recibidas');
      final List<dynamic> data = response.data;
      return data.map((json) => Solicitud.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener solicitudes recibidas',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<List<Solicitud>> getSentRequests() async {
    try {
      final response = await _dio.get('/solicitudes/me/enviadas');
      final List<dynamic> data = response.data;
      return data.map((json) => Solicitud.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener solicitudes enviadas',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Solicitud> createSolicitud({
    required String opportunityId,
    required String bio,
    required String professionalBackground,
    required List<String> preferredRegions,
    required double availableCapital,
    required bool financingNeeded,
    required bool ndaAccepted,
    String? message,
  }) async {
    try {
      final response = await _dio.post(
        '/solicitudes',
        data: {
          'opportunityId': opportunityId,
          'bio': bio,
          'professionalBackground': professionalBackground,
          'preferredRegions': preferredRegions,
          'availableCapital': availableCapital,
          'financingNeeded': financingNeeded,
          'ndaAccepted': ndaAccepted,
          if (message != null && message.isNotEmpty) 'message': message,
        },
      );
      return Solicitud.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al crear la solicitud',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Solicitud> updateRequestStatus(String id, String status) async {
    try {
      final response = await _dio.patch(
        '/solicitudes/$id/status',
        data: {'status': status},
      );
      return Solicitud.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al actualizar el estado de la solicitud',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getPresignedUploadUrl(String filename) async {
    try {
      final response = await _dio.get(
        '/storage/presigned-url',
        queryParameters: {'filename': filename},
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener URL de subida',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> uploadCvToS3(String uploadUrl, List<int> fileBytes) async {
    try {
      final uploadDio = Dio();
      await uploadDio.put(
        uploadUrl,
        data: Stream.fromIterable([fileBytes]),
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/pdf',
            Headers.contentLengthHeader: fileBytes.length,
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception('Error al subir el CV a S3: ${e.message}');
    }
  }

  Future<Solicitud> guardarCvKey(String id, String cvKey) async {
    try {
      final response = await _dio.patch(
        '/solicitudes/$id/guardar-cv',
        data: {'cvKey': cvKey},
      );
      return Solicitud.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al vincular el CV a la solicitud',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<String> getViewUrl(String id) async {
    try {
      final response = await _dio.get('/solicitudes/$id/ver-cv');
      return response.data['viewUrl'] as String;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al obtener la URL del CV',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Solicitud> analizarCvConIa(String id) async {
    try {
      final response = await _dio.post(
        '/solicitudes/$id/analizar-cv',
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
      return Solicitud.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Error al analizar el CV con IA',
        );
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
