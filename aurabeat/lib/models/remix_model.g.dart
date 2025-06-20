// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remix_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemixEffects _$RemixEffectsFromJson(Map<String, dynamic> json) => RemixEffects(
  volumeDb: (json['volumeDb'] as num?)?.toDouble(),
  fadeIn: (json['fadeIn'] as num?)?.toInt(),
  fadeOut: (json['fadeOut'] as num?)?.toInt(),
  tempo: (json['tempo'] as num?)?.toDouble(),
  normalize: json['normalize'] as bool?,
);

Map<String, dynamic> _$RemixEffectsToJson(RemixEffects instance) =>
    <String, dynamic>{
      'volumeDb': instance.volumeDb,
      'fadeIn': instance.fadeIn,
      'fadeOut': instance.fadeOut,
      'tempo': instance.tempo,
      'normalize': instance.normalize,
    };

RemixSegment _$RemixSegmentFromJson(Map<String, dynamic> json) => RemixSegment(
  source: json['source'] as String,
  section: json['section'] as String?,
  effects: json['effects'] == null
      ? null
      : RemixEffects.fromJson(json['effects'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RemixSegmentToJson(RemixSegment instance) =>
    <String, dynamic>{
      'source': instance.source,
      'section': instance.section,
      'effects': instance.effects,
    };

RemixRequest _$RemixRequestFromJson(Map<String, dynamic> json) => RemixRequest(
  structure: (json['structure'] as List<dynamic>)
      .map((e) => RemixSegment.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RemixRequestToJson(RemixRequest instance) =>
    <String, dynamic>{'structure': instance.structure};

RemixResponse _$RemixResponseFromJson(Map<String, dynamic> json) =>
    RemixResponse(
      message: json['message'] as String,
      remixTrack: json['remixTrack'] == null
          ? null
          : Track.fromJson(json['remixTrack'] as Map<String, dynamic>),
      remixFilepath: json['remixFilepath'] as String?,
    );

Map<String, dynamic> _$RemixResponseToJson(RemixResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'remixTrack': instance.remixTrack,
      'remixFilepath': instance.remixFilepath,
    };
