// // lib/providers/stem_provider.dart
// import 'package:flutter/foundation.dart';
// import '../models/stem_model.dart';
// import '../services/stem_service.dart';

// class StemProvider with ChangeNotifier {
//   final StemService _stemService = StemService();

//   Map<int, List<Stem>> _trackStems = {};
//   Map<int, List<StemSection>> _trackSections = {};
//   bool _isExtracting = false;
//   String? _error;

//   Map<int, List<Stem>> get trackStems => _trackStems;
//   Map<int, List<StemSection>> get trackSections => _trackSections;
//   bool get isExtracting => _isExtracting;
//   String? get error => _error;

//   List<Stem>? getStemsForTrack(int trackId) {
//     return _trackStems[trackId];
//   }

//   List<StemSection>? getSectionsForTrack(int trackId) {
//     return _trackSections[trackId];
//   }

//   Future<void> extractStems(int trackId) async {
//     _setExtracting(true);
//     _clearError();

//     try {
//       final response = await _stemService.extractStems(trackId);
//       if (response.stems != null) {
//         _trackStems[trackId] = response.stems!;
//         notifyListeners();
//       }
//     } catch (e) {
//       _setError(e.toString());
//     } finally {
//       _setExtracting(false);
//     }
//   }

//   Future<void> extractStemsAndSections(int trackId) async {
//     _setExtracting(true);
//     _clearError();

//     try {
//       final response = await _stemService.extractStemsAndSections(trackId);
//       if (response.stems != null) {
//         _trackStems[trackId] = response.stems!;
//       }
//       if (response.sections != null) {
//         _trackSections[trackId] = response.sections!;
//       }
//       notifyListeners();
//     } catch (e) {
//       _setError(e.toString());
//     } finally {
//       _setExtracting(false);
//     }
//   }

//   void _setExtracting(bool extracting) {
//     _isExtracting = extracting;
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

//******version 2 *********//
// lib/providers/stem_provider.dart
import 'package:flutter/foundation.dart';
import '../models/stem_model.dart';
import '../services/stem_service.dart';

class StemProvider with ChangeNotifier {
  final StemService _stemService = StemService();

  // Track-based storage
  Map<int, List<Stem>> _trackStems = {};
  Map<int, List<StemSection>> _trackSections = {};
  
  // Current active stems and sections (for the current track)
  Map<String, dynamic> _stems = {};
  Map<String, List<dynamic>> _sections = {};
  
  bool _isLoading = false;
  bool _isExtracting = false;
  String? _error;
  int? _currentTrackId;

  // Getters for backward compatibility
  Map<int, List<Stem>> get trackStems => _trackStems;
  Map<int, List<StemSection>> get trackSections => _trackSections;
  
  // Getters for current track stems/sections (what StemScreen expects)
  Map<String, dynamic> get stems => _stems;
  Map<String, List<dynamic>> get sections => _sections;
  
  bool get isLoading => _isLoading;
  bool get isExtracting => _isExtracting;
  String? get error => _error;

  List<Stem>? getStemsForTrack(int trackId) {
    return _trackStems[trackId];
  }

  List<StemSection>? getSectionsForTrack(int trackId) {
    return _trackSections[trackId];
  }

  // New method that StemScreen expects
  Future<void> getStems(int trackId) async {
    _setLoading(true);
    _clearError();
    _currentTrackId = trackId;

    try {
      // Load existing stems for this track if available
      final existingStems = _trackStems[trackId];
      final existingSections = _trackSections[trackId];
      
      if (existingStems != null) {
        _stems = _convertStemsToMap(existingStems);
      } else {
        _stems = {};
      }
      
      if (existingSections != null) {
        _sections = _convertSectionsToMap(existingSections);
      } else {
        _sections = {};
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> extractStems(int trackId) async {
    _setExtracting(true);
    _clearError();
    _currentTrackId = trackId;

    try {
      final response = await _stemService.extractStems(trackId);
      if (response.stems != null) {
        _trackStems[trackId] = response.stems!;
        _stems = _convertStemsToMap(response.stems!);
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setExtracting(false);
    }
  }

  Future<void> extractStemsAndSections(int trackId) async {
    _setExtracting(true);
    _clearError();
    _currentTrackId = trackId;

    try {
      final response = await _stemService.extractStemsAndSections(trackId);
      
      if (response.stems != null) {
        _trackStems[trackId] = response.stems!;
        _stems = _convertStemsToMap(response.stems!);
      }
      
      if (response.sections != null) {
        _trackSections[trackId] = response.sections!;
        _sections = _convertSectionsToMap(response.sections!);
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setExtracting(false);
    }
  }

  // Helper methods to convert List<Stem> to Map<String, dynamic>
  Map<String, dynamic> _convertStemsToMap(List<Stem> stems) {
    Map<String, dynamic> stemMap = {};
    for (var stem in stems) {
      stemMap[stem.name ?? 'unknown'] = stem;
    }
    return stemMap;
  }

  // Helper method to convert List<StemSection> to Map<String, List<dynamic>>
  Map<String, List<dynamic>> _convertSectionsToMap(List<StemSection> sections) {
    Map<String, List<dynamic>> sectionMap = {};
    
    // Group sections by stem name
    for (var section in sections) {
      final stemName = section.stemName ?? 'unknown';
      if (!sectionMap.containsKey(stemName)) {
        sectionMap[stemName] = [];
      }
      sectionMap[stemName]!.add(section);
    }
    
    return sectionMap;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setExtracting(bool extracting) {
    _isExtracting = extracting;
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

  // Clear current stems/sections when switching tracks
  void clearCurrentData() {
    _stems = {};
    _sections = {};
    _currentTrackId = null;
    notifyListeners();
  }
}