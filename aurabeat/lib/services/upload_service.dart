// // lib/services/upload_service.dart
// import 'dart:io';
// import 'package:dio/dio.dart';
// import '../core/utils/dio_client.dart';
// import '../core/constants/api_constants.dart';
// import '../models/track_model.dart';

// class UploadService {
//   //final DioClient _dioClient = DioClient();
//     final DioClient _dioClient = DioClient.instance;


//   Future<UploadResponse> uploadAudioFile(File file) async {
//     try {
//       final fileName = file.path.split('/').last;
//       final formData = FormData.fromMap({
//         'file': await MultipartFile.fromFile(
//           file.path,
//           filename: fileName,
//         ),
//       });

//       final response = await _dioClient.dio.post(
//         ApiConstants.upload,
//         data: formData,
//         options: Options(
//           headers: {'Content-Type': 'multipart/form-data'},
//         ),
//       );

//       return UploadResponse.fromJson(response.data);
//     } catch (e) {
//       throw Exception('Failed to upload file: $e');
//     }
//   }
// }


// lib/services/upload_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/track_model.dart';


class UploadService {
  final DioClient _dioClient = DioClient.instance;

  /// Upload audio file for mobile platforms
  Future<UploadResponse> uploadAudioFile(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await _dioClient.dio.post(
        ApiConstants.upload,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return UploadResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Upload audio file for web platforms
  Future<UploadResponse> uploadWebAudioFile(Uint8List fileBytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });

      final response = await _dioClient.dio.post(
        ApiConstants.upload,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return UploadResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to upload web file: $e');
    }
  }

  /// Universal upload method that handles both platforms
  Future<UploadResponse> uploadUniversal({
    File? file,
    Uint8List? fileBytes,
    required String fileName,
  }) async {
    try {
      late MultipartFile multipartFile;

      if (kIsWeb && fileBytes != null) {
        // Web platform: use bytes
        multipartFile = MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        );
      } else if (!kIsWeb && file != null) {
        // Mobile/Desktop platform: use file
        multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
      } else {
        throw Exception('Invalid file data provided');
      }

      final formData = FormData.fromMap({
        'file': multipartFile,
      });

      final response = await _dioClient.dio.post(
        ApiConstants.upload,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return UploadResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  ///fetch tracks method
  // Future<List<Track>> fetchTracks() async {
  // try {
  //   final response = await _dioClient.dio.get(ApiConstants.tracks); // e.g., "/api/tracks"
  //   print('Raw response: ${response.data}');
  //   final data = response.data as List;
  //   return data.map((json) => Track.fromJson(json)).toList();
  // } catch (e) {
  //   print('fetchTracks error: $e');
  //   throw Exception('Failed to load tracks: $e');
  // }
  // }
  Future<List<Track>> fetchTracks() async {
  try {
    final response = await _dioClient.dio.get(ApiConstants.tracks);
    final List<dynamic> rawList = response.data['tracks'];
    return rawList.map((json) => mapBackendJsonToTrack(json)).toList();
  } catch (e) {
    throw Exception('Failed to load tracks: $e');
  }
}


  /// Upload with progress callback
  Future<UploadResponse> uploadWithProgress({
    File? file,
    Uint8List? fileBytes,
    required String fileName,
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      late MultipartFile multipartFile;

      if (kIsWeb && fileBytes != null) {
        multipartFile = MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        );
      } else if (!kIsWeb && file != null) {
        multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
      } else {
        throw Exception('Invalid file data provided');
      }

      final formData = FormData.fromMap({
        'file': multipartFile,
      });

      final response = await _dioClient.dio.post(
        ApiConstants.upload,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
        onSendProgress: onProgress,
      );

      return UploadResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Get file size for progress calculations
  int getFileSize({File? file, Uint8List? fileBytes}) {
    if (kIsWeb && fileBytes != null) {
      return fileBytes.length;
    } else if (!kIsWeb && file != null) {
      return file.lengthSync();
    }
    return 0;
  }

  /// Validate file format
  bool isValidAudioFormat(String fileName) {
    final supportedFormats = ['mp3', 'wav', 'flac', 'm4a', 'aac', 'ogg'];
    final extension = fileName.split('.').last.toLowerCase();
    return supportedFormats.contains(extension);
  }

  /// Validate file size (max 50MB)
  bool isValidFileSize({File? file, Uint8List? fileBytes, int maxSizeMB = 50}) {
    final maxSizeBytes = maxSizeMB * 1024 * 1024;
    final fileSize = getFileSize(file: file, fileBytes: fileBytes);
    return fileSize <= maxSizeBytes;
  }

  /// Comprehensive file validation
  ValidationResult validateFile({
    File? file,
    Uint8List? fileBytes,
    required String fileName,
    int maxSizeMB = 50,
  }) {
    // Check if file data exists
    if ((kIsWeb && fileBytes == null) || (!kIsWeb && file == null)) {
      return ValidationResult(
        isValid: false,
        error: 'No file selected',
      );
    }

    // Check file format
    if (!isValidAudioFormat(fileName)) {
      return ValidationResult(
        isValid: false,
        error: 'Unsupported file format. Please use MP3, WAV, FLAC, M4A, AAC, or OGG.',
      );
    }

    // Check file size
    if (!isValidFileSize(file: file, fileBytes: fileBytes, maxSizeMB: maxSizeMB)) {
      return ValidationResult(
        isValid: false,
        error: 'File size exceeds ${maxSizeMB}MB limit.',
      );
    }

    return ValidationResult(isValid: true);
  }
}

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? error;

  ValidationResult({
    required this.isValid,
    this.error,
  });
}



Track mapBackendJsonToTrack(Map<String, dynamic> backendJson) {
  // Parse DateTime fields safely
  DateTime parseDate(String? dateStr) =>
      dateStr != null ? DateTime.parse(dateStr) : DateTime.now();

  // Filename fallback: if backend sends title, use it; else extract from file_path
  String extractFileName(String filePath) {
    return filePath.split('/').last;
  }

  final filepath = backendJson['file_path'] as String;
  final title = backendJson['title'] as String?;
  final filename = title ?? extractFileName(filepath);

  return Track(
    id: backendJson['id'],
    filename: filename,
    title: title,
    artist: backendJson['artist'],
    album: backendJson['album'],
    duration: (backendJson['duration'] != null)
        ? (backendJson['duration'] as num).toDouble()
        : null,
    userId: backendJson['user_id'],
    filepath: filepath,
    createdAt: parseDate(backendJson['uploaded_at']),
    updatedAt: parseDate(backendJson['updated_at']),
  );
}
