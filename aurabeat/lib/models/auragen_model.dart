// // lib/models/auragen_model.dart
// import 'package:json_annotation/json_annotation.dart';
// import 'package:equatable/equatable.dart';
// import 'track_model.dart';

// part 'auragen_model.g.dart';

// @JsonSerializable()
// class AuraGenRequest extends Equatable {
//   final String prompt;
//   final String? lyrics;

//   const AuraGenRequest({
//     required this.prompt,
//     this.lyrics,
//   });

//   factory AuraGenRequest.fromJson(Map<String, dynamic> json) =>
//       _$AuraGenRequestFromJson(json);
//   Map<String, dynamic> toJson() => _$AuraGenRequestToJson(this);

//   @override
//   List<Object?> get props => [prompt, lyrics];
// }

// @JsonSerializable()
// class AuraGenResponse extends Equatable {
//   final String message;
//   final Track? generatedTrack;
//   final String? jobId;
//   final String? status;

//   const AuraGenResponse({
//     required this.message,
//     this.generatedTrack,
//     this.jobId,
//     this.status,
//   });

//   factory AuraGenResponse.fromJson(Map<String, dynamic> json) =>
//       _$AuraGenResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$AuraGenResponseToJson(this);

//   @override
//   List<Object?> get props => [message, generatedTrack, jobId, status];
// }


import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'track_model.dart';

part 'auragen_model.g.dart';

@JsonSerializable()
class AuraGenRequest extends Equatable {
  final String prompt;
  final String? lyrics;

  const AuraGenRequest({
    required this.prompt,
    this.lyrics,
  });

  factory AuraGenRequest.fromJson(Map<String, dynamic> json) =>
      _$AuraGenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuraGenRequestToJson(this);

  @override
  List<Object?> get props => [prompt, lyrics];
}

@JsonSerializable()
class AuraGenResponse extends Equatable {
  final String message;
  final Track? generatedTrack;
  final String? jobId;
  final String? status;

  const AuraGenResponse({
    required this.message,
    this.generatedTrack,
    this.jobId,
    this.status,
  });

  /// Determines if the response indicates a successful AI track generation
  bool get isSuccess => message.toLowerCase() == 'ai track generated successfully';

  factory AuraGenResponse.fromJson(Map<String, dynamic> json) =>
      _$AuraGenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuraGenResponseToJson(this);

  @override
  List<Object?> get props => [message, generatedTrack, jobId, status];
}
