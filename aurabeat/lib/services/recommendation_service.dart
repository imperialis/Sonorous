// lib/services/recommendation_service.dart
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/recommendation_model.dart';

class RecommendationService {
  // final DioClient _dioClient = DioClient();
    final DioClient _dioClient = DioClient.instance;

  Future<RecommendationResponse> getRecommendations() async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.getRecommendations,
      );

      return RecommendationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }
}

