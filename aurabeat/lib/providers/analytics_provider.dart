// lib/providers/analytics_provider.dart
import 'package:flutter/foundation.dart';
import '../models/analytics_model.dart';
import '../services/analytics_service.dart';

class AnalyticsProvider with ChangeNotifier {
  final AnalyticsService _analyticsService = AnalyticsService();

  AnalyticsSummary? _summary;
  bool _isLoading = false;
  String? _error;

  AnalyticsSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAnalyticsSummary() async {
    _setLoading(true);
    _clearError();

    try {
      _summary = await _analyticsService.getAnalyticsSummary();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logEvent({
    required String event,
    String? userId,
    int? trackId,
    Map<String, dynamic>? details,
  }) async {
    try {
      await _analyticsService.logEvent(
        event: event,
        userId: userId,
        trackId: trackId,
        details: details,
      );
    } catch (e) {
      _setError(e.toString());
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
