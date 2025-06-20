// lib/services/tags_service.dart
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/tag_model.dart';

class TagsService {
  //final DioClient _dioClient = DioClient();
  final DioClient _dioClient = DioClient.instance;

  Future<TagResponse> addManualTags(int trackId, List<String> tags) async {
    try {
      final request = TagRequest(tags: tags);
      
      final response = await _dioClient.dio.post(
        '${ApiConstants.tagsAdd(trackId)}',
        data: request.toJson(),
      );

      return TagResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add manual tags: $e');
    }
  }

  Future<TagResponse> generateAITags(int trackId) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.tagsGenerate(trackId)}'
      );

      return TagResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to generate AI tags: $e');
    }
  }
}