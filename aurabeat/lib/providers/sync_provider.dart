
// lib/providers/sync_provider.dart
import 'package:flutter/foundation.dart';
import '../models/sync_model.dart';
import '../services/sync_service.dart';

class SyncProvider with ChangeNotifier {
  final SyncService _syncService = SyncService();

  PlaybackState? _currentState;
  bool _isSyncing = false;
  String? _error;

  PlaybackState? get currentState => _currentState;
  bool get isSyncing => _isSyncing;
  String? get error => _error;

  Future<void> updatePlaybackState({
    required int trackId,
    required double position,
    required bool isPlaying,
  }) async {
    _setSyncing(true);
    _clearError();

    try {
      await _syncService.updatePlaybackState(
        trackId: trackId,
        position: position,
        isPlaying: isPlaying,
      );
      
      _currentState = PlaybackState(
        trackId: trackId,
        position: position,
        isPlaying: isPlaying,
        lastUpdated: DateTime.now(),
      );
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setSyncing(false);
    }
  }

  Future<void> loadPlaybackState() async {
    _setSyncing(true);
    _clearError();

    try {
      _currentState = await _syncService.getPlaybackState();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setSyncing(false);
    }
  }

  void _setSyncing(bool syncing) {
    _isSyncing = syncing;
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
