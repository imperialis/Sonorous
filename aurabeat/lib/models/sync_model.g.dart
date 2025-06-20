// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaybackState _$PlaybackStateFromJson(Map<String, dynamic> json) =>
    PlaybackState(
      trackId: (json['trackId'] as num).toInt(),
      position: (json['position'] as num).toDouble(),
      isPlaying: json['isPlaying'] as bool,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$PlaybackStateToJson(PlaybackState instance) =>
    <String, dynamic>{
      'trackId': instance.trackId,
      'position': instance.position,
      'isPlaying': instance.isPlaying,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) => SyncResponse(
  message: json['message'] as String,
  state: json['state'] == null
      ? null
      : PlaybackState.fromJson(json['state'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SyncResponseToJson(SyncResponse instance) =>
    <String, dynamic>{'message': instance.message, 'state': instance.state};
