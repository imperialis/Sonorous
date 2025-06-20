// lib/services/remix_service.dart
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/remix_model.dart';

class RemixService {
  // final DioClient _dioClient = DioClient();
  final DioClient _dioClient = DioClient.instance;
  
  Future<RemixResponse> createRemix(int trackId, List<RemixSegment> structure) async {
    try {
      final request = RemixRequest(structure: structure);
      
      final response = await _dioClient.dio.post(
        '${ApiConstants.remixTrack}/$trackId',
        data: request.toJson(),
      );

      return RemixResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create remix: $e');
    }
  }
}
