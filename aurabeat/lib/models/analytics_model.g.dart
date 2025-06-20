// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsEvent _$AnalyticsEventFromJson(Map<String, dynamic> json) =>
    AnalyticsEvent(
      event: json['event'] as String,
      userId: json['userId'] as String?,
      trackId: (json['trackId'] as num?)?.toInt(),
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AnalyticsEventToJson(AnalyticsEvent instance) =>
    <String, dynamic>{
      'event': instance.event,
      'userId': instance.userId,
      'trackId': instance.trackId,
      'details': instance.details,
    };

AnalyticsSummary _$AnalyticsSummaryFromJson(Map<String, dynamic> json) =>
    AnalyticsSummary(
      totalEvents: (json['totalEvents'] as num).toInt(),
      uniqueUsers: (json['uniqueUsers'] as num).toInt(),
      tracksPlayed: (json['tracksPlayed'] as num).toInt(),
      remixesCreated: (json['remixesCreated'] as num).toInt(),
      eventCounts: (json['eventCounts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      topTracks: (json['topTracks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AnalyticsSummaryToJson(AnalyticsSummary instance) =>
    <String, dynamic>{
      'totalEvents': instance.totalEvents,
      'uniqueUsers': instance.uniqueUsers,
      'tracksPlayed': instance.tracksPlayed,
      'remixesCreated': instance.remixesCreated,
      'eventCounts': instance.eventCounts,
      'topTracks': instance.topTracks,
    };

AnalyticsResponse _$AnalyticsResponseFromJson(Map<String, dynamic> json) =>
    AnalyticsResponse(
      message: json['message'] as String,
      summary: json['summary'] == null
          ? null
          : AnalyticsSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnalyticsResponseToJson(AnalyticsResponse instance) =>
    <String, dynamic>{'message': instance.message, 'summary': instance.summary};
