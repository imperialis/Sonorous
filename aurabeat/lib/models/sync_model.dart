// lib/models/sync_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'sync_model.g.dart';

@JsonSerializable()
class PlaybackState extends Equatable {
  final int trackId;
  final double position;
  final bool isPlaying;
  final DateTime? lastUpdated;

  const PlaybackState({
    required this.trackId,
    required this.position,
    required this.isPlaying,
    this.lastUpdated,
  });

  factory PlaybackState.fromJson(Map<String, dynamic> json) =>
      _$PlaybackStateFromJson(json);
  Map<String, dynamic> toJson() => _$PlaybackStateToJson(this);

  @override
  List<Object?> get props => [trackId, position, isPlaying, lastUpdated];
}

@JsonSerializable()
class SyncResponse extends Equatable {
  final String message;
  final PlaybackState? state;

  const SyncResponse({
    required this.message,
    this.state,
  });

  factory SyncResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SyncResponseToJson(this);

  @override
  List<Object?> get props => [message, state];
}

