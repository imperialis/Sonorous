// lib/models/analytics_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'analytics_model.g.dart';

@JsonSerializable()
class AnalyticsEvent extends Equatable {
  final String event;
  final String? userId;
  final int? trackId;
  final Map<String, dynamic>? details;

  const AnalyticsEvent({
    required this.event,
    this.userId,
    this.trackId,
    this.details,
  });

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsEventFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsEventToJson(this);

  @override
  List<Object?> get props => [event, userId, trackId, details];
}

@JsonSerializable()
class AnalyticsSummary extends Equatable {
  final int totalEvents;
  final int uniqueUsers;
  final int tracksPlayed;
  final int remixesCreated;
  final Map<String, int>? eventCounts;
  final List<String>? topTracks;

  const AnalyticsSummary({
    required this.totalEvents,
    required this.uniqueUsers,
    required this.tracksPlayed,
    required this.remixesCreated,
    this.eventCounts,
    this.topTracks,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsSummaryToJson(this);

  @override
  List<Object?> get props => [
        totalEvents,
        uniqueUsers,
        tracksPlayed,
        remixesCreated,
        eventCounts,
        topTracks,
      ];
}

@JsonSerializable()
class AnalyticsResponse extends Equatable {
  final String message;
  final AnalyticsSummary? summary;

  const AnalyticsResponse({
    required this.message,
    this.summary,
  });

  factory AnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsResponseToJson(this);

  @override
  List<Object?> get props => [message, summary];
}