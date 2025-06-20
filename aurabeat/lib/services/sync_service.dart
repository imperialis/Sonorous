
// lib/services/sync_service.dart
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/sync_model.dart';

class SyncService {
  //final DioClient _dioClient = DioClient();
  final DioClient _dioClient = DioClient.instance;
  
  Future<SyncResponse> updatePlaybackState({
    required int trackId,
    required double position,
    required bool isPlaying,
  }) async {
    try {
      final state = PlaybackState(
        trackId: trackId,
        position: position,
        isPlaying: isPlaying,
      );

      final response = await _dioClient.dio.post(
        ApiConstants.updatePlaybackState,
        data: state.toJson(),
      );

      return SyncResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update playback state: $e');
    }
  }

  Future<PlaybackState> getPlaybackState() async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.getPlaybackState,
      );

      return PlaybackState.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get playback state: $e');
    }
  }
}

