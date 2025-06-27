// // lib/services/stem_service.dart
// import '../core/utils/dio_client.dart';
// import '../core/constants/api_constants.dart';
// import '../models/stem_model.dart';

// class StemService {
//   //final DioClient _dioClient = DioClient();
//   final DioClient _dioClient = DioClient.instance;
  
//   Future<StemResponse> extractStems(int trackId) async {
//     try {
//       final response = await _dioClient.dio.post(
//         '${ApiConstants.stemExtract(trackId)}',
//       );

//       return StemResponse.fromJson(response.data);
//     } catch (e) {
//       throw Exception('Failed to extract stems: $e');
//     }
//   }

//   Future<StemResponse> extractStemsAndSections(int trackId) async {
//     try {
//       final response = await _dioClient.dio.post(
//         '${ApiConstants.stemExtractSections(trackId)}',
//       );

//       return StemResponse.fromJson(response.data);
//     } catch (e) {
//       throw Exception('Failed to extract stems and sections: $e');
//     }
//   }
// }

import 'package:flutter/foundation.dart';
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/stem_model.dart';

class StemService {
  final DioClient _dioClient = DioClient.instance;

  Future<StemResponse> extractStems(int trackId) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.stemExtract(trackId)}',
      );

      final data = response.data;
      final stemMap = data['stems'] as Map<String, dynamic>;
      final List<Stem> stems = _mapStemsFromResponse(stemMap, trackId);
      debugPrint('Mapped stems 4rm stemservice: ${stems.map((s) => s.toJson())}');
      return StemResponse(message: data['message'], stems: stems);
    } catch (e) {
      throw Exception('Failed to extract stems: $e');
    }
  }

  Future<StemResponse> extractStemsAndSections(int trackId) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.stemExtractSections(trackId)}',
      );

      final data = response.data;
      final stemMap = data['stems'] as Map<String, dynamic>;
      final sectionMap = data['sections'] as Map<String, dynamic>;

      final List<Stem> stems = _mapStemsFromResponse(stemMap, trackId);
      final List<StemSection> sections = _mapSectionsFromResponse(sectionMap, stems);
      debugPrint('Mapped stems 4rm stemservice: ${stems.map((s) => s.toJson())}');
      return StemResponse(
        message: data['message'],
        stems: stems,
        sections: sections,
      );
    } catch (e) {
      throw Exception('Failed to extract stems and sections: $e');
    }
  }

  /// Maps raw stems from backend (Map<String, String>) to List<Stem>
  List<Stem> _mapStemsFromResponse(Map<String, dynamic> stemMap, int trackId) {
    int idCounter = 1;
    final DateTime now = DateTime.now();
    //debugPrint('Mapped sections: ${sections.map((s) => s.toJson())}');
    return stemMap.entries.map((entry) {
      return Stem(
        id: idCounter++,
        name: entry.key,
        stemType: entry.key.split('.').first,
        filepath: entry.value,
        createdAt: now,
        trackId: trackId,
      );
    }).toList();
     //debugPrint('Mapped stems: ${stems.map((s) => s.toJson()).toList()}');
  }

  /// Maps raw sections from backend (Map<String, List<String>>) to List<StemSection>
  List<StemSection> _mapSectionsFromResponse(Map<String, dynamic> sectionMap, List<Stem> stems) {
    int idCounter = 1;
    List<StemSection> result = [];

    for (final entry in sectionMap.entries) {
      final stemName = entry.key;
      final List<dynamic> paths = entry.value;
      final stem = stems.firstWhere((s) => s.name == stemName, orElse: () => throw Exception('Stem not found for section: $stemName'));

      for (int i = 0; i < paths.length; i++) {
        final path = paths[i];

        result.add(
          StemSection(
            id: idCounter++,
            stemId: stem.id,
            stemName: stem.name,
            sectionName: 'Section ${i + 1}',
            startTime: 0.0,
            endTime: 0.0,
            filepath: path,
          ),
        );
      }
    }
    debugPrint('Mapped sections: ${result.map((s) => s.toJson()).toList()}');
    return result;
  }
}
