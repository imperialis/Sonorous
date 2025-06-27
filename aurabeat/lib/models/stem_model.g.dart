// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stem_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stem _$StemFromJson(Map<String, dynamic> json) => Stem(
  id: (json['id'] as num).toInt(),
  trackId: (json['trackId'] as num).toInt(),
  stemType: json['stemType'] as String,
  filepath: json['filepath'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  duration: (json['duration'] as num?)?.toDouble(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$StemToJson(Stem instance) => <String, dynamic>{
  'id': instance.id,
  'trackId': instance.trackId,
  'stemType': instance.stemType,
  'filepath': instance.filepath,
  'duration': instance.duration,
  'createdAt': instance.createdAt.toIso8601String(),
  'name': instance.name,
};

StemSection _$StemSectionFromJson(Map<String, dynamic> json) => StemSection(
  id: (json['id'] as num).toInt(),
  stemId: (json['stemId'] as num).toInt(),
  sectionName: json['sectionName'] as String,
  stemName: json['stemName'] as String?,
  startTime: (json['startTime'] as num).toDouble(),
  endTime: (json['endTime'] as num).toDouble(),
  filepath: json['filepath'] as String,
);

Map<String, dynamic> _$StemSectionToJson(StemSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stemId': instance.stemId,
      'sectionName': instance.sectionName,
      'stemName': instance.stemName,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'filepath': instance.filepath,
    };

StemResponse _$StemResponseFromJson(Map<String, dynamic> json) => StemResponse(
  message: json['message'] as String,
  stems: (json['stems'] as List<dynamic>?)
      ?.map((e) => Stem.fromJson(e as Map<String, dynamic>))
      .toList(),
  sections: (json['sections'] as List<dynamic>?)
      ?.map((e) => StemSection.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StemResponseToJson(StemResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'stems': instance.stems,
      'sections': instance.sections,
    };
