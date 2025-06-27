// lib/services/lyrics_service.dart
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/lyrics_model.dart';
import 'package:dio/dio.dart'; 
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

/// Only for web:
import 'dart:html' as html;


// import 'dart:io' as io;
// import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:path_provider/path_provider.dart';
// import 'dart:html' as html; // Only used in web

class LyricsService {
  // final DioClient _dioClient = DioClient();
    final DioClient _dioClient = DioClient.instance;
    final String baseUrl = 'https://obscure-guacamole-69rq46qv47rwc55w5-5000.app.github.dev/'; // e.g. "https://api.yourdomain.com"

  Future<Lyrics> transcribeLyrics(int trackId) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.lyricsTranscribe(trackId)}',
      );

      //return LyricsResponse.fromJson(response.data);
      final data = response.data['lyrics']; 
      print("DEBUG response.data['lyrics']: $data");
      return LyricsMapper.fromTrackJson(data);
    } catch (e) {
      throw Exception('Failed to transcribe lyrics : $e');
    }
  }

  Future<Lyrics> editLyrics(int trackId, String lyrics) async {
    try {
      final request = LyricsRequest(lyrics: lyrics);
      
      final response = await _dioClient.dio.post(
        '${ApiConstants.lyricsEdit(trackId)}',
        data: request.toJson(),
      );

      //return LyricsResponse.fromJson(response.data);
      final data = response.data['lyrics']; // use 'lyrics' key from backend
      return LyricsMapper.fromTrackJson(data);
    } catch (e) {
      throw Exception('Failed to edit lyrics: $e');
    }
  }

  Future<Lyrics> getLyrics(int trackId) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.lyricsGet(trackId)}',
      );

      //return Lyrics.fromJson(response.data);
      final data = response.data['lyrics']; // use 'lyrics' key from backend
      return LyricsMapper.fromTrackJson(data);
    } catch (e) {
      throw Exception('Failed to get lyrics: $e');
    }
  }

//   Future<String> exportLyrics(int trackId) async {
//     try {
//       final response = await _dioClient.dio.get(
//         '${ApiConstants.lyricsExport(trackId)}',
//         options: Options(responseType: ResponseType.bytes),
//       );

//       // Return the file path or save the bytes
//       return 'track_${trackId}_lyrics.txt';
//     } catch (e) {
//       throw Exception('Failed to export lyrics: $e');
//     }
//   }

Future<String> exportLyrics(int trackId) async {
  try {
    // Step 1: Request export and get download URL
    final exportResponse = await _dioClient.get(
      ApiConstants.lyricsExport(trackId),
    );

    final relativeUrl = exportResponse.data['download_url'];
    if (relativeUrl == null) {
      throw Exception('No download URL returned from export.');
    }

    final fullDownloadUrl = '$baseUrl$relativeUrl';

    // Step 2: Download the file bytes
    final downloadResponse = await Dio().get(
      fullDownloadUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final Uint8List bytes = Uint8List.fromList(downloadResponse.data);
    final fileName = 'track_${trackId}_lyrics.txt';

    if (kIsWeb) {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..style.display = 'none';

      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();

      html.Url.revokeObjectUrl(url);

      return 'Downloaded via browser';
    } else {
      // Mobile/Desktop
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return filePath;
    }
  } catch (e) {
    throw Exception('Failed to export and download lyrics: $e');
  }
}

}
// lib/mappers/lyrics_mapper.dart

class LyricsMapper {
  static Lyrics fromTrackJson(Map<String, dynamic> json) {
    return Lyrics(
      id: json['id'] ?? 0,
      trackId: json['id'] ?? 0, // or another field if different
      content: json['lyrics'] ?? '',
      isTranscribed: (json['lyrics'] as String?)?.trim().isNotEmpty ?? false,
      createdAt: DateTime.tryParse(json['uploaded_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}

