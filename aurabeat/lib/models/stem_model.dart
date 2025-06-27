// // lib/models/stem_model.dart
// import 'package:json_annotation/json_annotation.dart';
// import 'package:equatable/equatable.dart';

// part 'stem_model.g.dart';

// @JsonSerializable()
// class Stem extends Equatable {
//   final int id;
//     final int trackId;
//       final String stemType;
//         final String filepath;
//           final double? duration;
//             final DateTime createdAt;
//               final String? name;

//                 const Stem({
//                     required this.id,
//                         this.name,
//                             required this.trackId,
//                                 required this.stemType,
//                                     required this.filepath,
//                                         this.duration,
//                                             required this.createdAt,
//                                               });

//                                                 factory Stem.fromJson(Map<String, dynamic> json) => _$StemFromJson(json);
//                                                   Map<String, dynamic> toJson() => _$StemToJson(this);

//                                                     @override
//                                                       List<Object?> get props => [
//                                                               id,
//                                                                       trackId,
//                                                                               name,
//                                                                                       stemType,
//                                                                                               filepath,
//                                                                                                       duration,
//                                                                                                               createdAt,
//                                                                                                                     ];
//                                                                                                                     }

//                                                                                                                     @JsonSerializable()
//                                                                                                                     class StemSection extends Equatable {
//                                                                                                                       final int id;
//                                                                                                                         final int stemId;
//                                                                                                                           final String sectionName;
//                                                                                                                             final String? stemName;
//                                                                                                                               final double startTime;
//                                                                                                                                 final double endTime;
//                                                                                                                                   final String filepath;

//                                                                                                                                     const StemSection({
//                                                                                                                                         required this.id,
//                                                                                                                                             required this.stemId,
//                                                                                                                                                 required this.sectionName,
//                                                                                                                                                      this.stemName,
//                                                                                                                                                          required this.startTime,
//                                                                                                                                                              required this.endTime,
//                                                                                                                                                                  required this.filepath,
//                                                                                                                                                                    });

//                                                                                                                                                                      factory StemSection.fromJson(Map<String, dynamic> json) =>
//                                                                                                                                                                            _$StemSectionFromJson(json);
//                                                                                                                                                                              Map<String, dynamic> toJson() => _$StemSectionToJson(this);

//                                                                                                                                                                                @override
//                                                                                                                                                                                  List<Object> get props => [
//                                                                                                                                                                                          id,
//                                                                                                                                                                                                  stemId,
//                                                                                                                                                                                                          stemName ?? '',
//                                                                                                                                                                                                                  sectionName,
//                                                                                                                                                                                                                          startTime,
//                                                                                                                                                                                                                                  endTime,
//                                                                                                                                                                                                                                          filepath,
//                                                                                                                                                                                                                                                ];
//                                                                                                                                                                                                                                                }

//                                                                                                                                                                                                                                                @JsonSerializable()
//                                                                                                                                                                                                                                                class StemResponse extends Equatable {
//                                                                                                                                                                                                                                                  final String message;
//                                                                                                                                                                                                                                                    final List<Stem>? stems;
//                                                                                                                                                                                                                                                      final List<StemSection>? sections;

//                                                                                                                                                                                                                                                        const StemResponse({
//                                                                                                                                                                                                                                                            required this.message,
//                                                                                                                                                                                                                                                                this.stems,
//                                                                                                                                                                                                                                                                    this.sections,
//                                                                                                                                                                                                                                                                      });

//                                                                                                                                                                                                                                                                        factory StemResponse.fromJson(Map<String, dynamic> json) =>
//                                                                                                                                                                                                                                                                              _$StemResponseFromJson(json);
//                                                                                                                                                                                                                                                                                Map<String, dynamic> toJson() => _$StemResponseToJson(this);

//                                                                                                                                                                                                                                                                                  @override
//                                                                                                                                                                                                                                                                                    List<Object?> get props => [message, stems, sections];
//                                                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                                   import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'stem_model.g.dart';

/// Represents a single stem (e.g., vocals, bass).
@JsonSerializable()
class Stem extends Equatable {
  final int id;
  final int trackId;
  final String stemType;
  final String filepath;
  final double? duration;
  final DateTime createdAt;
  final String? name;

  const Stem({
    required this.id,
    required this.trackId,
    required this.stemType,
    required this.filepath,
    required this.createdAt,
    this.duration,
    this.name,
  });

  factory Stem.fromJson(Map<String, dynamic> json) => _$StemFromJson(json);
  Map<String, dynamic> toJson() => _$StemToJson(this);

  @override
  List<Object?> get props => [
        id,
        trackId,
        stemType,
        filepath,
        duration,
        createdAt,
        name,
      ];
}

/// Represents a musical section (e.g., verse, chorus) within a stem.
@JsonSerializable()
class StemSection extends Equatable {
  final int id;
  final int stemId;
  final String sectionName;
  final String? stemName;
  final double startTime;
  final double endTime;
  final String filepath;

  const StemSection({
    required this.id,
    required this.stemId,
    required this.sectionName,
    this.stemName,
    required this.startTime,
    required this.endTime,
    required this.filepath,
  });

  factory StemSection.fromJson(Map<String, dynamic> json) =>
      _$StemSectionFromJson(json);

  Map<String, dynamic> toJson() => _$StemSectionToJson(this);

  @override
  List<Object> get props => [
        id,
        stemId,
        sectionName,
        stemName ?? '',
        startTime,
        endTime,
        filepath,
      ];
}

/// Represents the response from the backend after extracting stems/sections.
@JsonSerializable()
class StemResponse extends Equatable {
  final String message;
  final List<Stem>? stems;
  final List<StemSection>? sections;

  const StemResponse({
    required this.message,
    this.stems,
    this.sections,
  });

  factory StemResponse.fromJson(Map<String, dynamic> json) =>
      _$StemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StemResponseToJson(this);

  @override
  List<Object?> get props => [message, stems, sections];
}
                

