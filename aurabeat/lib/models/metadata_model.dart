// lib/models/metadata_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'metadata_model.g.dart';

@JsonSerializable()
class AudioMetadata extends Equatable {
  final String? title;
  final String? artist;
  final String? album;
  final String? genre;
  final int? year;
  final int? trackNumber;
  final double? duration;
  final int? bitrate;
  final int? sampleRate;
  final String? format;
  final int? fileSize;

  const AudioMetadata({
    this.title,
    this.artist,
    this.album,
    this.genre,
    this.year,
    this.trackNumber,
    this.duration,
    this.bitrate,
    this.sampleRate,
    this.format,
    this.fileSize,
  });

  factory AudioMetadata.fromJson(Map<String, dynamic> json) =>
      _$AudioMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$AudioMetadataToJson(this);

  @override
  List<Object?> get props => [
        title,
        artist,
        album,
        genre,
        year,
        trackNumber,
        duration,
        bitrate,
        sampleRate,
        format,
        fileSize,
      ];
}
