// // lib/models/remix_model.dart
// import 'package:json_annotation/json_annotation.dart';
// import 'package:equatable/equatable.dart';
// import 'track_model.dart';

// part 'remix_model.g.dart';

// // added the below to fix naming error
// typedef RemixStructure = RemixSegment;

// @JsonSerializable()
// class RemixEffects extends Equatable {
//   final double? volumeDb;
//   final int? fadeIn;
//   final int? fadeOut;
//   final double? tempo;
//   final bool? normalize;

//   const RemixEffects({
//     this.volumeDb,
//     this.fadeIn,
//     this.fadeOut,
//     this.tempo,
//     this.normalize,
//   });

//   factory RemixEffects.fromJson(Map<String, dynamic> json) =>
//       _$RemixEffectsFromJson(json);
//   Map<String, dynamic> toJson() => _$RemixEffectsToJson(this);

//   @override
//   List<Object?> get props => [volumeDb, fadeIn, fadeOut, tempo, normalize];
// }

// @JsonSerializable()
// class RemixSegment extends Equatable {
//   final String source;
//   final String? section;
//   final RemixEffects? effects;

//   const RemixSegment({
//     required this.source,
//     this.section,
//     this.effects,
//   });

//   factory RemixSegment.fromJson(Map<String, dynamic> json) =>
//       _$RemixSegmentFromJson(json);
//   Map<String, dynamic> toJson() => _$RemixSegmentToJson(this);

//   @override
//   List<Object?> get props => [source, section, effects];
// }

// @JsonSerializable()
// class RemixRequest extends Equatable {
//   final List<RemixSegment> structure;

//   const RemixRequest({required this.structure});

//   factory RemixRequest.fromJson(Map<String, dynamic> json) =>
//       _$RemixRequestFromJson(json);
//   Map<String, dynamic> toJson() => _$RemixRequestToJson(this);

//   @override
//   List<Object> get props => [structure];
// }

// @JsonSerializable()
// class RemixResponse extends Equatable {
//   final String message;
//   final Track? remixTrack;
//   final String? remixFilepath;

//   const RemixResponse({
//     required this.message,
//     this.remixTrack,
//     this.remixFilepath,
//   });

//   factory RemixResponse.fromJson(Map<String, dynamic> json) =>
//       _$RemixResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$RemixResponseToJson(this);

//   @override
//   List<Object?> get props => [message, remixTrack, remixFilepath];
// }

import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'track_model.dart';

part 'remix_model.g.dart';

// Added to fix naming error
typedef RemixStructure = RemixSegment;

@JsonSerializable()
class RemixEffects extends Equatable {
  final double? volumeDb;
  final int? fadeIn;
  final int? fadeOut;
  final double? tempo;
  final bool? normalize;

  const RemixEffects({
    this.volumeDb,
    this.fadeIn,
    this.fadeOut,
    this.tempo,
    this.normalize,
  });

  RemixEffects copyWith({
    double? volumeDb,
    int? fadeIn,
    int? fadeOut,
    double? tempo,
    bool? normalize,
  }) {
    return RemixEffects(
      volumeDb: volumeDb ?? this.volumeDb,
      fadeIn: fadeIn ?? this.fadeIn,
      fadeOut: fadeOut ?? this.fadeOut,
      tempo: tempo ?? this.tempo,
      normalize: normalize ?? this.normalize,
    );
  }

  factory RemixEffects.fromJson(Map<String, dynamic> json) =>
      _$RemixEffectsFromJson(json);
  Map<String, dynamic> toJson() => _$RemixEffectsToJson(this);

  @override
  List<Object?> get props => [volumeDb, fadeIn, fadeOut, tempo, normalize];
}

@JsonSerializable()
class RemixSegment extends Equatable {
  final String source;
  final String? section;
  final RemixEffects? effects;

  const RemixSegment({
    required this.source,
    this.section,
    this.effects,
  });

  RemixSegment copyWith({
    String? source,
    String? section,
    RemixEffects? effects,
  }) {
    return RemixSegment(
      source: source ?? this.source,
      section: section ?? this.section,
      effects: effects ?? this.effects,
    );
  }

  factory RemixSegment.fromJson(Map<String, dynamic> json) =>
      _$RemixSegmentFromJson(json);
  Map<String, dynamic> toJson() => _$RemixSegmentToJson(this);

  @override
  List<Object?> get props => [source, section, effects];
}

@JsonSerializable()
class RemixRequest extends Equatable {
  final List<RemixSegment> structure;

  const RemixRequest({required this.structure});

  factory RemixRequest.fromJson(Map<String, dynamic> json) =>
      _$RemixRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RemixRequestToJson(this);

  @override
  List<Object> get props => [structure];
}

@JsonSerializable()
class RemixResponse extends Equatable {
  final String message;
  final Track? remixTrack;
  final String? remixFilepath;

  const RemixResponse({
    required this.message,
    this.remixTrack,
    this.remixFilepath,
  });

  factory RemixResponse.fromJson(Map<String, dynamic> json) =>
      _$RemixResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RemixResponseToJson(this);

  @override
  List<Object?> get props => [message, remixTrack, remixFilepath];
}
