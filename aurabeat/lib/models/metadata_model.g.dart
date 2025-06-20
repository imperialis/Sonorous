// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioMetadata _$AudioMetadataFromJson(Map<String, dynamic> json) =>
    AudioMetadata(
      title: json['title'] as String?,
      artist: json['artist'] as String?,
      album: json['album'] as String?,
      genre: json['genre'] as String?,
      year: (json['year'] as num?)?.toInt(),
      trackNumber: (json['trackNumber'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toDouble(),
      bitrate: (json['bitrate'] as num?)?.toInt(),
      sampleRate: (json['sampleRate'] as num?)?.toInt(),
      format: json['format'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AudioMetadataToJson(AudioMetadata instance) =>
    <String, dynamic>{
      'title': instance.title,
      'artist': instance.artist,
      'album': instance.album,
      'genre': instance.genre,
      'year': instance.year,
      'trackNumber': instance.trackNumber,
      'duration': instance.duration,
      'bitrate': instance.bitrate,
      'sampleRate': instance.sampleRate,
      'format': instance.format,
      'fileSize': instance.fileSize,
    };
