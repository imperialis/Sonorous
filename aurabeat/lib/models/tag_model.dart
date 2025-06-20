// lib/models/tag_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'tag_model.g.dart';

@JsonSerializable()
class Tag extends Equatable {
  final int id;
  final String name;
  final String type; // 'manual' or 'ai_generated'
  final double? confidence;
  final DateTime createdAt;

  const Tag({
    required this.id,
    required this.name,
    required this.type,
    this.confidence,
    required this.createdAt,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);

  @override
  List<Object?> get props => [id, name, type, confidence, createdAt];
}

@JsonSerializable()
class TrackTag extends Equatable {
  final int id;
  final int trackId;
  final int tagId;
  final Tag tag;

  const TrackTag({
    required this.id,
    required this.trackId,
    required this.tagId,
    required this.tag,
  });

  factory TrackTag.fromJson(Map<String, dynamic> json) =>
      _$TrackTagFromJson(json);
  Map<String, dynamic> toJson() => _$TrackTagToJson(this);

  @override
  List<Object> get props => [id, trackId, tagId, tag];
}

@JsonSerializable()
class TagRequest extends Equatable {
  final List<String> tags;

  const TagRequest({required this.tags});

  factory TagRequest.fromJson(Map<String, dynamic> json) =>
      _$TagRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TagRequestToJson(this);

  @override
  List<Object> get props => [tags];
}

@JsonSerializable()
class TagResponse extends Equatable {
  final String message;
  final List<TrackTag>? trackTags;

  const TagResponse({
    required this.message,
    this.trackTags,
  });

  factory TagResponse.fromJson(Map<String, dynamic> json) =>
      _$TagResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TagResponseToJson(this);

  @override
  List<Object?> get props => [message, trackTags];
}

