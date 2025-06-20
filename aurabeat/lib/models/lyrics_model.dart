// lib/models/lyrics_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'lyrics_model.g.dart';

@JsonSerializable()
class Lyrics extends Equatable {
  final int id;
  final int trackId;
  final String content;
  final bool isTranscribed;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get lyrics => content;


  const Lyrics({
    required this.id,
    required this.trackId,
    required this.content,
    required this.isTranscribed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) => _$LyricsFromJson(json);
  Map<String, dynamic> toJson() => _$LyricsToJson(this);

  @override
  List<Object> get props => [
        id,
        trackId,
        content,
        isTranscribed,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class LyricsRequest extends Equatable {
  final String lyrics;

  const LyricsRequest({required this.lyrics});

  factory LyricsRequest.fromJson(Map<String, dynamic> json) =>
      _$LyricsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LyricsRequestToJson(this);

  @override
  List<Object> get props => [lyrics];
}

@JsonSerializable()
class LyricsResponse extends Equatable {
  final String message;
  final Lyrics? lyrics;

  const LyricsResponse({
    required this.message,
    this.lyrics,
  });

  factory LyricsResponse.fromJson(Map<String, dynamic> json) =>
      _$LyricsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LyricsResponseToJson(this);

  @override
  List<Object?> get props => [message, lyrics];
}