// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  type: json['type'] as String,
  confidence: (json['confidence'] as num?)?.toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'confidence': instance.confidence,
  'createdAt': instance.createdAt.toIso8601String(),
};

TrackTag _$TrackTagFromJson(Map<String, dynamic> json) => TrackTag(
  id: (json['id'] as num).toInt(),
  trackId: (json['trackId'] as num).toInt(),
  tagId: (json['tagId'] as num).toInt(),
  tag: Tag.fromJson(json['tag'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TrackTagToJson(TrackTag instance) => <String, dynamic>{
  'id': instance.id,
  'trackId': instance.trackId,
  'tagId': instance.tagId,
  'tag': instance.tag,
};

TagRequest _$TagRequestFromJson(Map<String, dynamic> json) => TagRequest(
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$TagRequestToJson(TagRequest instance) =>
    <String, dynamic>{'tags': instance.tags};

TagResponse _$TagResponseFromJson(Map<String, dynamic> json) => TagResponse(
  message: json['message'] as String,
  trackTags: (json['trackTags'] as List<dynamic>?)
      ?.map((e) => TrackTag.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TagResponseToJson(TagResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'trackTags': instance.trackTags,
    };
