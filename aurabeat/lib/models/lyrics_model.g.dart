// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lyrics _$LyricsFromJson(Map<String, dynamic> json) => Lyrics(
  id: (json['id'] as num).toInt(),
  trackId: (json['trackId'] as num).toInt(),
  content: json['content'] as String,
  isTranscribed: json['isTranscribed'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$LyricsToJson(Lyrics instance) => <String, dynamic>{
  'id': instance.id,
  'trackId': instance.trackId,
  'content': instance.content,
  'isTranscribed': instance.isTranscribed,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

LyricsRequest _$LyricsRequestFromJson(Map<String, dynamic> json) =>
    LyricsRequest(lyrics: json['lyrics'] as String);

Map<String, dynamic> _$LyricsRequestToJson(LyricsRequest instance) =>
    <String, dynamic>{'lyrics': instance.lyrics};

LyricsResponse _$LyricsResponseFromJson(Map<String, dynamic> json) =>
    LyricsResponse(
      message: json['message'] as String,
      lyrics: json['lyrics'] == null
          ? null
          : Lyrics.fromJson(json['lyrics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LyricsResponseToJson(LyricsResponse instance) =>
    <String, dynamic>{'message': instance.message, 'lyrics': instance.lyrics};
