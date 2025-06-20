// lib/services/lyrics_service.dart
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/lyrics_model.dart';
import 'package:dio/dio.dart'; 

class LyricsService {
  // final DioClient _dioClient = DioClient();
    final DioClient _dioClient = DioClient.instance;

  Future<LyricsResponse> transcribeLyrics(int trackId) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.lyricsTranscribe(trackId)}',
      );

      return LyricsResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to transcribe lyrics: $e');
    }
  }

  Future<LyricsResponse> editLyrics(int trackId, String lyrics) async {
    try {
      final request = LyricsRequest(lyrics: lyrics);
      
      final response = await _dioClient.dio.post(
        '${ApiConstants.lyricsEdit(trackId)}',
        data: request.toJson(),
      );

      return LyricsResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to edit lyrics: $e');
    }
  }

  Future<Lyrics> getLyrics(int trackId) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.lyricsGet(trackId)}',
      );

      return Lyrics.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get lyrics: $e');
    }
  }

  Future<String> exportLyrics(int trackId) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.lyricsExport(trackId)}',
        options: Options(responseType: ResponseType.bytes),
      );

      // Return the file path or save the bytes
      return 'track_${trackId}_lyrics.txt';
    } catch (e) {
      throw Exception('Failed to export lyrics: $e');
    }
  }
}