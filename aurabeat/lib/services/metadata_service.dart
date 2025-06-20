// lib/services/metadata_service.dart
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/metadata_model.dart';

class MetadataService {
  // final DioClient _dioClient = DioClient();
    final DioClient _dioClient = DioClient.instance;

  Future<AudioMetadata> extractMetadata(int trackId) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.extractMetadata}/$trackId',
      );

      return AudioMetadata.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to extract metadata: $e');
    }
  }
}

