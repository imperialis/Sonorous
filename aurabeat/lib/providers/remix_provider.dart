// lib/providers/remix_provider.dart
import 'package:flutter/foundation.dart';
import '../models/remix_model.dart';
import '../models/track_model.dart';
import '../services/remix_service.dart';

class RemixProvider with ChangeNotifier {
  final RemixService _remixService = RemixService();

  List<RemixSegment> _remixStructure = [];
  bool _isCreatingRemix = false;
  String? _error;
  Track? _lastRemixTrack;

  List<RemixSegment> get remixStructure => _remixStructure;
  bool get isCreatingRemix => _isCreatingRemix;
  String? get error => _error;
  Track? get lastRemixTrack => _lastRemixTrack;

  void addRemixSegment(RemixSegment segment) {
    _remixStructure.add(segment);
    notifyListeners();
  }

  void removeRemixSegment(int index) {
    if (index >= 0 && index < _remixStructure.length) {
      _remixStructure.removeAt(index);
      notifyListeners();
    }
  }

  void updateRemixSegment(int index, RemixSegment segment) {
    if (index >= 0 && index < _remixStructure.length) {
      _remixStructure[index] = segment;
      notifyListeners();
    }
  }

  void clearRemixStructure() {
    _remixStructure.clear();
    notifyListeners();
  }

  Future<void> createRemix(int trackId, List<RemixStructure> structure) async {
    if (_remixStructure.isEmpty) {
      _setError('Remix structure cannot be empty');
      return;
    }

    _setCreatingRemix(true);
    _clearError();

    try {
      final response = await _remixService.createRemix(trackId, _remixStructure);
      if (response.remixTrack != null) {
        _lastRemixTrack = response.remixTrack;
        _remixStructure.clear();
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setCreatingRemix(false);
    }
  }

  void _setCreatingRemix(bool creating) {
    _isCreatingRemix = creating;
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

