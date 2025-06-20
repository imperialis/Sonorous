// lib/services/auragen_service.dart
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/auragen_model.dart';

class AuraGenService {
  // final DioClient _dioClient = DioClient();
    final DioClient _dioClient = DioClient.instance;

  Future<AuraGenResponse> generateAITrack({
    required String prompt,
    String? lyrics,
  }) async {
    try {
      final request = AuraGenRequest(prompt: prompt, lyrics: lyrics);
      
      final response = await _dioClient.dio.post(
        ApiConstants.auragenGenerate,
        data: request.toJson(),
      );

      return AuraGenResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to generate AI track: $e');
    }
  }
}
