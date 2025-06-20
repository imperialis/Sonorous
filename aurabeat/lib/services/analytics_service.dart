// lib/services/analytics_service.dart
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/analytics_model.dart';

class AnalyticsService {
    final DioClient _dioClient = DioClient.instance;
  //final DioClient _dioClient = DioClient();

  Future<void> logEvent({
    required String event,
    String? userId,
    int? trackId,
    Map<String, dynamic>? details,
  }) async {
    try {
      final analyticsEvent = AnalyticsEvent(
        event: event,
        userId: userId,
        trackId: trackId,
        details: details,
      );

      await _dioClient.dio.post(
        ApiConstants.analyticsLog,
        data: analyticsEvent.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to log event: $e');
    }
  }

  Future<AnalyticsSummary> getAnalyticsSummary() async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.analyticsSummary,
      );

      return AnalyticsSummary.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get analytics summary: $e');
    }
  }
}
