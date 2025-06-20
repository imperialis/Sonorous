 

// //**************version 2***********
// // lib/models/track_model.dart (Complete)
// import 'package:json_annotation/json_annotation.dart';
// import 'package:equatable/equatable.dart';

// part 'track_model.g.dart';

// @JsonSerializable()
// class Track extends Equatable {
//   final int id;
//   final String filename;
//   final String? title;
//   final String? artist;
//   final String? album;
//   final double? duration;
//   final int? userId;
//   final String filepath;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   const Track({
//     required this.id,
//     required this.filename,
//     this.title,
//     this.artist,
//     this.album,
//     this.duration,
//     this.userId,
//     required this.filepath,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
//   Map<String, dynamic> toJson() => _$TrackToJson(this);

//   @override
//   List<Object?> get props => [
//         id,
//         filename,
//         title,
//         artist,
//         album,
//         duration,
//         userId,
//         filepath,
//         createdAt,
//         updatedAt,
//       ];
// }

// @JsonSerializable()
// class UploadResponse extends Equatable {
//   final String message;
//   final Track track;

//   const UploadResponse({
//     required this.message,
//     required this.track,
//   });

//   factory UploadResponse.fromJson(Map<String, dynamic> json) =>
//       _$UploadResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$UploadResponseToJson(this);

//   @override
//   List<Object> get props => [message, track];
// }

 

//**************version 2***********
// lib/models/track_model.dart (Complete)
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'track_model.g.dart';

@JsonSerializable()
class Track extends Equatable {
  final int id;
  final String filename;
  final String? title;
  final String? artist;
  final String? album;
  final double? duration;
  final int? userId;
  final String filepath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Track({
    required this.id,
    required this.filename,
    this.title,
    this.artist,
    this.album,
    this.duration,
    this.userId,
    required this.filepath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
  Map<String, dynamic> toJson() => _$TrackToJson(this);

  @override
  List<Object?> get props => [
        id,
        filename,
        title,
        artist,
        album,
        duration,
        userId,
        filepath,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class UploadResponse extends Equatable {
  final String message;
  final Track track;

  const UploadResponse({
    required this.message,
    required this.track,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);

  @override
  List<Object> get props => [message, track];
}