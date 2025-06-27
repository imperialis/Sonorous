// // lib/providers/lyrics_provider.dart
// import 'package:flutter/foundation.dart';
// import '../models/lyrics_model.dart';
// import '../services/lyrics_service.dart';

// class LyricsProvider with ChangeNotifier {
//   final LyricsService _lyricsService = LyricsService();

//   Map<int, Lyrics> _trackLyrics = {};
//   bool _isLoading = false;
//   String? _error;
//   bool _isTranscribing = false;

//   Map<int, Lyrics> get trackLyrics => _trackLyrics;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isTranscribing => _isTranscribing;

//   Lyrics? getLyricsForTrack(int trackId) {
//     return _trackLyrics[trackId];
//   }

//   Lyrics? currentLyrics(int trackId) {
//     return _trackLyrics[trackId];
//   }

//   Lyrics? get currentLyrics {
//   return _trackLyrics[trackId!];
// }


//   Future<void> transcribeLyrics(int trackId) async {
//     _setTranscribing(true);
//     _clearError();

//     try {
//       final response = await _lyricsService.transcribeLyrics(trackId);
//       if (response.lyrics != null) {
//         _trackLyrics[trackId] = response.lyrics!;
//         notifyListeners();
//       }
//     } catch (e) {
//       _setError(e.toString());
//     } finally {
//       _setTranscribing(false);
//     }
//   }

//   Future<void> editLyrics(int trackId, String lyrics) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final response = await _lyricsService.editLyrics(trackId, lyrics);
//       if (response.lyrics != null) {
//         _trackLyrics[trackId] = response.lyrics!;
//         notifyListeners();
//       }
//     } catch (e) {
//       _setError(e.toString());
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> loadLyrics(int trackId) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final lyrics = await _lyricsService.getLyrics(trackId);
//       _trackLyrics[trackId] = lyrics;
//       notifyListeners();
//     } catch (e) {
//       _setError(e.toString());
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> currentLyrics(int trackId) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final lyrics = await _lyricsService.getLyrics(trackId);
//       _trackLyrics[trackId] = lyrics;
//       notifyListeners();
//     } catch (e) {
//       _setError(e.toString());
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> exportLyrics(int trackId) async {
//     try {
//       await _lyricsService.exportLyrics(trackId);
//     } catch (e) {
//       _setError(e.toString());
//     }
//   }

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setTranscribing(bool transcribing) {
//     _isTranscribing = transcribing;
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



import 'package:flutter/foundation.dart';
import '../models/lyrics_model.dart';
import '../services/lyrics_service.dart';

class LyricsProvider with ChangeNotifier {
  final LyricsService _lyricsService = LyricsService();

  final Map<int, Lyrics> _trackLyrics = {};
  int? _currentTrackId;
  bool _isLoading = false;
  String? _error;
  bool _isTranscribing = false;

  // Getters
  Map<int, Lyrics> get trackLyrics => _trackLyrics;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTranscribing => _isTranscribing;
  int? get currentTrackId => _currentTrackId;

  // Set current track ID
  set currentTrackId(int? id) {
    _currentTrackId = id;
    notifyListeners(); // Optional, only if UI should update when changing ID
  }

  // Main currentLyrics getter
  Lyrics? get currentLyrics {
    if (_currentTrackId == null) return null;
    return _trackLyrics[_currentTrackId!];
  }

  // Fetch lyrics for specific track
  Lyrics? getLyricsForTrack(int trackId) {
    return _trackLyrics[trackId];
  }

  // Load lyrics from service
  Future<void> loadLyrics(int trackId) async {
    _setLoading(true);
    _clearError();
    try {
      final lyrics = await _lyricsService.getLyrics(trackId);
      _trackLyrics[trackId] = lyrics;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> transcribeLyrics(int trackId) async {
    _setTranscribing(true);
    _clearError();
    try {
      final response = await _lyricsService.transcribeLyrics(trackId);
      // if (response.lyrics != null) {
      //   _trackLyrics[trackId] = response.lyrics!;
      _trackLyrics[trackId] = response;

        notifyListeners();
      //}
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setTranscribing(false);
    }
  }

  Future<void> editLyrics(int trackId, String lyrics) async {
    _setLoading(true);
    _clearError();
    try {
      final response = await _lyricsService.editLyrics(trackId, lyrics);
      // if (response.lyrics != null) {
      //   _trackLyrics[trackId] = response.lyrics!;
      _trackLyrics[trackId] = response;
        notifyListeners();
      //}
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> exportLyrics(int trackId) async {
    try {
      await _lyricsService.exportLyrics(trackId);
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setTranscribing(bool transcribing) {
    _isTranscribing = transcribing;
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
