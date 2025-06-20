// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
  id: (json['id'] as num).toInt(),
  filename: json['filename'] as String,
  title: json['title'] as String?,
  artist: json['artist'] as String?,
  album: json['album'] as String?,
  duration: (json['duration'] as num?)?.toDouble(),
  userId: (json['userId'] as num?)?.toInt(),
  filepath: json['filepath'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
  'id': instance.id,
  'filename': instance.filename,
  'title': instance.title,
  'artist': instance.artist,
  'album': instance.album,
  'duration': instance.duration,
  'userId': instance.userId,
  'filepath': instance.filepath,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

UploadResponse _$UploadResponseFromJson(Map<String, dynamic> json) =>
    UploadResponse(
      message: json['message'] as String,
      track: Track.fromJson(json['track'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UploadResponseToJson(UploadResponse instance) =>
    <String, dynamic>{'message': instance.message, 'track': instance.track};
