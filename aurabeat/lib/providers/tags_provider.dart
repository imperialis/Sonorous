
// lib/providers/tags_provider.dart
import 'package:flutter/foundation.dart';
import '../models/tag_model.dart';
import '../services/tags_service.dart';

class TagsProvider with ChangeNotifier {
  final TagsService _tagsService = TagsService();

  Map<int, List<TrackTag>> _trackTags = {};
  bool _isLoading = false;
  String? _error;

  Map<int, List<TrackTag>> get trackTags => _trackTags;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<TrackTag>? getTagsForTrack(int trackId) {
    return _trackTags[trackId];
  }

  Future<void> addManualTags(int trackId, List<String> tags) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _tagsService.addManualTags(trackId, tags);
      if (response.trackTags != null) {
        _trackTags[trackId] = response.trackTags!;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> generateAITags(int trackId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _tagsService.generateAITags(trackId);
      if (response.trackTags != null) {
        _trackTags[trackId] = response.trackTags!;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
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