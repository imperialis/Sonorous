// import 'dart:io';
// import 'dart:typed_data';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:path/path.dart' as path;
// import 'package:permission_handler/permission_handler.dart';

// class AudioHelper {
//   static final AudioHelper _instance = AudioHelper._internal();
//   factory AudioHelper() => _instance;
//   AudioHelper._internal();

//   final AudioPlayer _audioPlayer = AudioPlayer();
  
//   // Audio format validation
//   static const List<String> supportedFormats = [
//     '.mp3',
//     '.m4a',
//     '.wav',
//     '.aac',
//     '.ogg',
//     '.flac'
//   ];

//   /// Check if the audio file format is supported
//   static bool isSupportedFormat(String filePath) {
//     final extension = path.extension(filePath).toLowerCase();
//     return supportedFormats.contains(extension);
//   }

//   /// Validate audio file
//   static bool isValidAudioFile(File file) {
//     if (!file.existsSync()) {
//       return false;
//     }
    
//     final extension = path.extension(file.path).toLowerCase();
//     return supportedFormats.contains(extension);
//   }

//   /// Get audio file format from path
//   static String getAudioFormat(String filePath) {
//     return path.extension(filePath).toLowerCase().replaceFirst('.', '');
//   }

//   /// Get formatted file size
//   static String getFormattedFileSize(int bytes) {
//     if (bytes < 1024) {
//       return '$bytes B';
//     } else if (bytes < 1024 * 1024) {
//       return '${(bytes / 1024).toStringAsFixed(1)} KB';
//     } else if (bytes < 1024 * 1024 * 1024) {
//       return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
//     } else {
//       return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
//     }
//   }

//   /// Request audio permissions
//   static Future<bool> requestAudioPermissions() async {
//     if (Platform.isAndroid) {
//       final status = await Permission.storage.request();
//       return status.isGranted;
//     } else if (Platform.isIOS) {
//       final status = await Permission.microphone.request();
//       return status.isGranted;
//     }
//     return true;
//   }

//   /// Play audio from file path
//   Future<void> playAudio(String filePath) async {
//     try {
//       await _audioPlayer.play(DeviceFileSource(filePath));
//     } catch (e) {
//       throw Exception('Failed to play audio: $e');
//     }
//   }

//   /// Play audio from URL
//   Future<void> playAudioFromUrl(String url) async {
//     try {
//       await _audioPlayer.play(UrlSource(url));
//     } catch (e) {
//       throw Exception('Failed to play audio from URL: $e');
//     }
//   }

//   /// Pause audio playback
//   Future<void> pauseAudio() async {
//     try {
//       await _audioPlayer.pause();
//     } catch (e) {
//       throw Exception('Failed to pause audio: $e');
//     }
//   }

//   /// Resume audio playback
//   Future<void> resumeAudio() async {
//     try {
//       await _audioPlayer.resume();
//     } catch (e) {
//       throw Exception('Failed to resume audio: $e');
//     }
//   }

//   /// Stop audio playback
//   Future<void> stopAudio() async {
//     try {
//       await _audioPlayer.stop();
//     } catch (e) {
//       throw Exception('Failed to stop audio: $e');
//     }
//   }

//   /// Seek to position in audio
//   Future<void> seekTo(Duration position) async {
//     try {
//       await _audioPlayer.seek(position);
//     } catch (e) {
//       throw Exception('Failed to seek audio: $e');
//     }
//   }

//   /// Set audio volume (0.0 to 1.0)
//   Future<void> setVolume(double volume) async {
//     try {
//       final clampedVolume = volume.clamp(0.0, 1.0);
//       await _audioPlayer.setVolume(clampedVolume);
//     } catch (e) {
//       throw Exception('Failed to set volume: $e');
//     }
//   }

//   /// Set playback rate/speed
//   Future<void> setPlaybackRate(double rate) async {
//     try {
//       final clampedRate = rate.clamp(0.5, 2.0);
//       await _audioPlayer.setPlaybackRate(clampedRate);
//     } catch (e) {
//       throw Exception('Failed to set playback rate: $e');
//     }
//   }

//   /// Get current playback position
//   Future<Duration?> getCurrentPosition() async {
//     try {
//       return await _audioPlayer.getCurrentPosition();
//     } catch (e) {
//       throw Exception('Failed to get current position: $e');
//     }
//   }

//   /// Get audio duration
//   Future<Duration?> getDuration() async {
//     try {
//       return await _audioPlayer.getDuration();
//     } catch (e) {
//       throw Exception('Failed to get duration: $e');
//     }
//   }

//   /// Get current player state
//   PlayerState get playerState => _audioPlayer.state;

//   /// Check if audio is playing
//   bool get isPlaying => _audioPlayer.state == PlayerState.playing;

//   /// Check if audio is paused
//   bool get isPaused => _audioPlayer.state == PlayerState.paused;

//   /// Check if audio is stopped
//   bool get isStopped => _audioPlayer.state == PlayerState.stopped;

//   /// Listen to player state changes
//   Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;

//   /// Listen to position changes
//   Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;

//   /// Listen to duration changes
//   Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;

//   /// Convert audio file to bytes
//   static Future<Uint8List> audioFileToBytes(File audioFile) async {
//     try {
//       return await audioFile.readAsBytes();
//     } catch (e) {
//       throw Exception('Failed to convert audio file to bytes: $e');
//     }
//   }

//   /// Validate audio file size (max 50MB for uploads)
//   static bool isValidFileSize(File file, {int maxSizeInMB = 50}) {
//     final fileSizeInMB = file.lengthSync() / (1024 * 1024);
//     return fileSizeInMB <= maxSizeInMB;
//   }

//   /// Get audio metadata (basic info)
//   static Map<String, dynamic> getBasicAudioInfo(File audioFile) {
//     final stats = audioFile.statSync();
//     final extension = path.extension(audioFile.path).toLowerCase();
    
//     return {
//       'fileName': path.basename(audioFile.path),
//       'filePath': audioFile.path,
//       'fileSize': stats.size,
//       'formattedSize': getFormattedFileSize(stats.size),
//       'format': extension.replaceFirst('.', ''),
//       'lastModified': stats.modified,
//       'isValid': isValidAudioFile(audioFile),
//       'isValidSize': isValidFileSize(audioFile),
//     };
//   }

//   /// Format duration to readable string
//   static String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes.remainder(60);
//     final seconds = duration.inSeconds.remainder(60);
    
//     if (hours > 0) {
//       return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
//     } else {
//       return '${twoDigits(minutes)}:${twoDigits(seconds)}';
//     }
//   }

//   /// Convert seconds to Duration
//   static Duration secondsToDuration(double seconds) {
//     return Duration(milliseconds: (seconds * 1000).round());
//   }

//   /// Convert Duration to seconds
//   static double durationToSeconds(Duration duration) {
//     return duration.inMilliseconds / 1000.0;
//   }

//   /// Create audio waveform data (placeholder - would need actual audio analysis)
//   static List<double> generateWaveformData(int dataPoints) {
//     // This is a placeholder. In a real app, you'd use audio analysis libraries
//     // to generate actual waveform data from the audio file
//     final List<double> waveform = [];
//     for (int i = 0; i < dataPoints; i++) {
//       // Generate pseudo-random waveform data between 0.1 and 1.0
//       waveform.add(0.1 + (i % 10) * 0.09);
//     }
//     return waveform;
//   }

//   /// Dispose audio player resources
//   void dispose() {
//     _audioPlayer.dispose();
//   }

//   /// Reset audio player to initial state
//   Future<void> reset() async {
//     try {
//       await _audioPlayer.stop();
//       await _audioPlayer.setVolume(1.0);
//       await _audioPlayer.setPlaybackRate(1.0);
//     } catch (e) {
//       throw Exception('Failed to reset audio player: $e');
//     }
//   }

//   /// Create audio session for background playback
//   Future<void> configureAudioSession() async {
//     try {
//       // Configure audio session for background playback on iOS
//       if (Platform.isIOS) {
//         await _audioPlayer.setAudioContext(
//           AudioContext(
//             iOS: AudioContextIOS(
//               category: AVAudioSessionCategory.playback,
//               options: [AVAudioSessionOptions.mixWithOthers],
//             ),
//             android: AudioContextAndroid(
//               isSpeakerphoneOn: false,
//               stayAwake: true,
//               contentType: AndroidContentType.music,
//               usageType: AndroidUsageType.media,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       // Audio session configuration failed, but this shouldn't break the app
//       print('Audio session configuration failed: $e');
//     }
//   }
// }


import 'dart:io';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class AudioHelper {
  static final AudioHelper _instance = AudioHelper._internal();
  factory AudioHelper() => _instance;
  AudioHelper._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Audio format validation
  static const List<String> supportedFormats = [
    '.mp3',
    '.m4a',
    '.wav',
    '.aac',
    '.ogg',
    '.flac'
  ];

  /// Check if the audio file format is supported
  static bool isSupportedFormat(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return supportedFormats.contains(extension);
  }

  /// Validate audio file
  static bool isValidAudioFile(File file) {
    if (!file.existsSync()) {
      return false;
    }
    
    final extension = path.extension(file.path).toLowerCase();
    return supportedFormats.contains(extension);
  }

  /// Get audio file format from path
  static String getAudioFormat(String filePath) {
    return path.extension(filePath).toLowerCase().replaceFirst('.', '');
  }

  /// Get formatted file size
  static String getFormattedFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Request audio permissions
  static Future<bool> requestAudioPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      final status = await Permission.microphone.request();
      return status.isGranted;
    }
    return true;
  }

  /// Play audio from file path
  Future<void> playAudio(String filePath) async {
    try {
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }

  /// Play audio from URL
  Future<void> playAudioFromUrl(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      throw Exception('Failed to play audio from URL: $e');
    }
  }

  /// Set audio source from file path
  Future<void> setAudioSource(String filePath) async {
    try {
      await _audioPlayer.setFilePath(filePath);
    } catch (e) {
      throw Exception('Failed to set audio source: $e');
    }
  }

  /// Set audio source from URL
  Future<void> setAudioSourceFromUrl(String url) async {
    try {
      await _audioPlayer.setUrl(url);
    } catch (e) {
      throw Exception('Failed to set audio source from URL: $e');
    }
  }

  /// Play audio
  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }

  /// Pause audio playback
  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      throw Exception('Failed to pause audio: $e');
    }
  }

  /// Stop audio playback
  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      throw Exception('Failed to stop audio: $e');
    }
  }

  /// Seek to position in audio
  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      throw Exception('Failed to seek audio: $e');
    }
  }

  /// Set audio volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      final clampedVolume = volume.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(clampedVolume);
    } catch (e) {
      throw Exception('Failed to set volume: $e');
    }
  }

  /// Set playback rate/speed
  Future<void> setSpeed(double speed) async {
    try {
      final clampedSpeed = speed.clamp(0.5, 2.0);
      await _audioPlayer.setSpeed(clampedSpeed);
    } catch (e) {
      throw Exception('Failed to set playback speed: $e');
    }
  }

  /// Get current playback position
  Duration? get currentPosition => _audioPlayer.position;

  /// Get audio duration
  Duration? get duration => _audioPlayer.duration;

  /// Get current player state
  PlayerState get playerState => _audioPlayer.playerState;

  /// Get current processing state
  ProcessingState get processingState => _audioPlayer.processingState;

  /// Check if audio is playing
  bool get isPlaying => _audioPlayer.playing;

  /// Check if audio is paused
  bool get isPaused => !_audioPlayer.playing && _audioPlayer.processingState != ProcessingState.idle;

  /// Check if audio is stopped
  bool get isStopped => _audioPlayer.processingState == ProcessingState.idle;

  /// Check if audio is buffering
  bool get isBuffering => _audioPlayer.processingState == ProcessingState.buffering;

  /// Check if audio is loading
  bool get isLoading => _audioPlayer.processingState == ProcessingState.loading;

  /// Listen to player state changes
  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.playerStateStream;

  /// Listen to playing state changes
  Stream<bool> get onPlayingChanged => _audioPlayer.playingStream;

  /// Listen to position changes
  Stream<Duration> get onPositionChanged => _audioPlayer.positionStream;

  /// Listen to duration changes
  Stream<Duration?> get onDurationChanged => _audioPlayer.durationStream;

  /// Listen to processing state changes
  Stream<ProcessingState> get onProcessingStateChanged => _audioPlayer.processingStateStream;

  /// Convert audio file to bytes
  static Future<Uint8List> audioFileToBytes(File audioFile) async {
    try {
      return await audioFile.readAsBytes();
    } catch (e) {
      throw Exception('Failed to convert audio file to bytes: $e');
    }
  }

  /// Validate audio file size (max 50MB for uploads)
  static bool isValidFileSize(File file, {int maxSizeInMB = 50}) {
    final fileSizeInMB = file.lengthSync() / (1024 * 1024);
    return fileSizeInMB <= maxSizeInMB;
  }

  /// Get audio metadata (basic info)
  static Map<String, dynamic> getBasicAudioInfo(File audioFile) {
    final stats = audioFile.statSync();
    final extension = path.extension(audioFile.path).toLowerCase();
    
    return {
      'fileName': path.basename(audioFile.path),
      'filePath': audioFile.path,
      'fileSize': stats.size,
      'formattedSize': getFormattedFileSize(stats.size),
      'format': extension.replaceFirst('.', ''),
      'lastModified': stats.modified,
      'isValid': isValidAudioFile(audioFile),
      'isValidSize': isValidFileSize(audioFile),
    };
  }

  /// Format duration to readable string
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  /// Convert seconds to Duration
  static Duration secondsToDuration(double seconds) {
    return Duration(milliseconds: (seconds * 1000).round());
  }

  /// Convert Duration to seconds
  static double durationToSeconds(Duration duration) {
    return duration.inMilliseconds / 1000.0;
  }

  /// Create audio waveform data (placeholder - would need actual audio analysis)
  static List<double> generateWaveformData(int dataPoints) {
    // This is a placeholder. In a real app, you'd use audio analysis libraries
    // to generate actual waveform data from the audio file
    final List<double> waveform = [];
    for (int i = 0; i < dataPoints; i++) {
      // Generate pseudo-random waveform data between 0.1 and 1.0
      waveform.add(0.1 + (i % 10) * 0.09);
    }
    return waveform;
  }

  /// Dispose audio player resources
  void dispose() {
    _audioPlayer.dispose();
  }

  /// Reset audio player to initial state
  Future<void> reset() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setSpeed(1.0);
    } catch (e) {
      throw Exception('Failed to reset audio player: $e');
    }
  }

  /// Set loop mode
  Future<void> setLoopMode(LoopMode loopMode) async {
    try {
      await _audioPlayer.setLoopMode(loopMode);
    } catch (e) {
      throw Exception('Failed to set loop mode: $e');
    }
  }

  /// Set shuffle mode
  Future<void> setShuffleModeEnabled(bool enabled) async {
    try {
      await _audioPlayer.setShuffleModeEnabled(enabled);
    } catch (e) {
      throw Exception('Failed to set shuffle mode: $e');
    }
  }

  /// Load audio from asset
  Future<void> setAsset(String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);
    } catch (e) {
      throw Exception('Failed to load audio asset: $e');
    }
  }

  /// Create playlist and load it
  Future<void> setPlaylist(List<AudioSource> sources) async {
    try {
      final playlist = ConcatenatingAudioSource(children: sources);
      await _audioPlayer.setAudioSource(playlist);
    } catch (e) {
      throw Exception('Failed to set playlist: $e');
    }
  }

  /// Create audio source from file path
  static AudioSource createFileSource(String filePath) {
    return AudioSource.file(filePath);
  }

  /// Create audio source from URL
  static AudioSource createUrlSource(String url) {
    return AudioSource.uri(Uri.parse(url));
  }

  /// Create audio source from asset
  static AudioSource createAssetSource(String assetPath) {
    return AudioSource.asset(assetPath);
  }

  /// Create audio session for background playback
  Future<void> configureAudioSession() async {
    try {
      // just_audio handles audio session configuration automatically
      // But we can set additional options if needed
      await _audioPlayer.setLoopMode(LoopMode.off);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setSpeed(1.0);
    } catch (e) {
      // Audio session configuration failed, but this shouldn't break the app
      print('Audio session configuration failed: $e');
    }
  }
}