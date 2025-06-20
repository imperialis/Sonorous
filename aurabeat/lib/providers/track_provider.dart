// // lib/providers/track_provider.dart
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import '../models/track_model.dart';
// import '../services/upload_service.dart';
// import '../services/analytics_service.dart';

// class TrackProvider with ChangeNotifier {
//   final UploadService _uploadService = UploadService();
//   final AnalyticsService _analyticsService = AnalyticsService();

//   List<Track> _tracks = [];
//   bool _isLoading = false;
//   String? _error;
//   Track? _currentTrack;

//   List<Track> get tracks => _tracks;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   Track? get currentTrack => _currentTrack;

//   void setCurrentTrack(Track track) {
//     _currentTrack = track;
//     _analyticsService.logEvent(
//       event: 'track_selected',
//       trackId: track.id,
//     );
//     notifyListeners();
//   }

//   Future<void> uploadTrack(File file) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final response = await _uploadService.uploadAudioFile(file);
//       _tracks.add(response.track);
      
//       await _analyticsService.logEvent(
//         event: 'track_uploaded',
//         trackId: response.track.id,
//         details: {'filename': response.track.filename},
//       );
      
//       notifyListeners();
//     } catch (e) {
//       _setError(e.toString());
//     } finally {
//       _setLoading(false);
//     }
//   }

//   void addTrack(Track track) {
//     _tracks.add(track);
//     notifyListeners();
//   }

//   void removeTrack(int trackId) {
//     _tracks.removeWhere((track) => track.id == trackId);
//     if (_currentTrack?.id == trackId) {
//       _currentTrack = null;
//     }
//     notifyListeners();
//   }

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String error) {
//     _error = error;
//     notifyListeners();
//   }

//   void _clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }


// lib/providers/track_provider.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/track_model.dart';
import '../services/upload_service.dart';
import '../services/analytics_service.dart';

class TrackProvider with ChangeNotifier {
  final UploadService _uploadService = UploadService();
  final AnalyticsService _analyticsService = AnalyticsService();

  List<Track> _tracks = [];
  bool _isLoading = false;
  String? _error;
  Track? _currentTrack;

  List<Track> get tracks => _tracks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Track? get currentTrack => _currentTrack;

  // Add the missing loadTracks method
  Future<void> loadTracks() async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Replace with actual API call to fetch tracks
      // For now, this is a placeholder implementation
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      // You'll need to implement the actual API call here
      // final tracks = await _uploadService.fetchTracks();
      // _tracks = tracks;
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void setCurrentTrack(Track track) {
    _currentTrack = track;
    _analyticsService.logEvent(
      event: 'track_selected',
      trackId: track.id,
    );
    notifyListeners();
  }

  Future<void> uploadTrack(File file) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _uploadService.uploadAudioFile(file);
      _tracks.add(response.track);
      
      await _analyticsService.logEvent(
        event: 'track_uploaded',
        trackId: response.track.id,
        details: {'filename': response.track.filename},
      );
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void addTrack(Track track) {
    _tracks.add(track);
    notifyListeners();
  }

  void removeTrack(int trackId) {
    _tracks.removeWhere((track) => track.id == trackId);
    if (_currentTrack?.id == trackId) {
      _currentTrack = null;
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}