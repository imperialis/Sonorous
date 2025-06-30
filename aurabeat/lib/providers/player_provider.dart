// // lib/providers/player_provider.dart
// import 'package:flutter/foundation.dart';
// import '../models/track_model.dart';

// class PlayerProvider extends ChangeNotifier {
//   Track? _currentTrack;
//   List<Track>? _playlist;

//   Track? get currentTrack => _currentTrack;
//   List<Track>? get playlist => _playlist;

//   void setTrack(Track track, List<Track> playlist) {
//     _currentTrack = track;
//     _playlist = playlist;
//     notifyListeners();
//   }
// }

// lib/providers/player_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/track_model.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration? _sectionEndTime;

  Track? _currentTrack;
  List<Track>? _playlist;

  Track? get currentTrack => _currentTrack;
  List<Track>? get playlist => _playlist;
  bool get isPlaying => _audioPlayer.playing;

  PlayerProvider() {
    _audioPlayer.positionStream.listen((pos) {
      if (_sectionEndTime != null && pos >= _sectionEndTime!) {
        _audioPlayer.pause();
        _sectionEndTime = null;
        notifyListeners();
      }
    });
  }

  void setTrack(Track track, List<Track> playlist) {
    _currentTrack = track;
    _playlist = playlist;
    notifyListeners();
  }

  Future<void> playSource(String path, {Track? track}) async {
    try {
      await _audioPlayer.setFilePath(path);
      _sectionEndTime = null;
      await _audioPlayer.play();

      if (track != null) {
        _currentTrack = track;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('🔴 Error playing source: $e');
    }
  }

  Future<void> playSection(String path, Duration start, Duration end) async {
    try {
      await _audioPlayer.setFilePath(path);
      await _audioPlayer.seek(start);
      _sectionEndTime = end;
      await _audioPlayer.play();
      notifyListeners();
    } catch (e) {
      debugPrint('🔴 Error playing section: $e');
    }
  }

  void pause() {
    _audioPlayer.pause();
    _sectionEndTime = null;
    notifyListeners();
  }

  void stop() {
    _audioPlayer.stop();
    _sectionEndTime = null;
    notifyListeners();
  }
}
