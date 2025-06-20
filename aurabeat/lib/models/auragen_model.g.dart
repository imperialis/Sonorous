// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auragen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuraGenRequest _$AuraGenRequestFromJson(Map<String, dynamic> json) =>
    AuraGenRequest(
      prompt: json['prompt'] as String,
      lyrics: json['lyrics'] as String?,
    );

Map<String, dynamic> _$AuraGenRequestToJson(AuraGenRequest instance) =>
    <String, dynamic>{'prompt': instance.prompt, 'lyrics': instance.lyrics};

AuraGenResponse _$AuraGenResponseFromJson(Map<String, dynamic> json) =>
    AuraGenResponse(
      message: json['message'] as String,
      generatedTrack: json['generatedTrack'] == null
          ? null
          : Track.fromJson(json['generatedTrack'] as Map<String, dynamic>),
      jobId: json['jobId'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$AuraGenResponseToJson(AuraGenResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'generatedTrack': instance.generatedTrack,
      'jobId': instance.jobId,
      'status': instance.status,
    };
