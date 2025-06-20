// lib/services/stem_service.dart
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/stem_model.dart';

class StemService {
  //final DioClient _dioClient = DioClient();
  final DioClient _dioClient = DioClient.instance;
  
  Future<StemResponse> extractStems(int trackId) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.stemExtract(trackId)}',
      );

      return StemResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to extract stems: $e');
    }
  }

  Future<StemResponse> extractStemsAndSections(int trackId) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.stemExtractSections(trackId)}',
      );

      return StemResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to extract stems and sections: $e');
    }
  }
}
