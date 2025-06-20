// lib/models/recommendation_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'track_model.dart';

part 'recommendation_model.g.dart';

@JsonSerializable()
class RecommendationResponse extends Equatable {
  final String message;
  final List<int> recommendedTrackIds;
  final List<Track>? recommendedTracks;

  const RecommendationResponse({
    required this.message,
    required this.recommendedTrackIds,
    this.recommendedTracks,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationResponseToJson(this);

  @override
  List<Object?> get props => [message, recommendedTrackIds, recommendedTracks];
}