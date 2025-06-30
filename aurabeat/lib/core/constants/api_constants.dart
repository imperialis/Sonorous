class ApiConstants {
  //static const String baseUrl = 'http://localhost:5000';
  static const String baseUrl = 'https://sonorous.fly.dev/';
  
  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  
  // Upload endpoints
  static const String upload = '/api/upload/';
  //static const String tracks = '/api/tracks';
  static const String tracks = '/api/upload/';

  
  // AuraGen endpoints
  static const String auragenGenerate = '/api/auragen/generate';
  
  // Analytics endpoints
  static const String analyticsLog = '/api/analytics/log';
  static const String analyticsSummary = '/api/analytics/summary';
  
  // Lyrics endpoints
  static String lyricsTranscribe(int trackId) => '/api/lyrics/$trackId/transcribe';
  static String lyricsEdit(int trackId) => '/api/lyrics/$trackId/edit';
  static String lyricsGet(int trackId) => '/api/lyrics/$trackId';
  static String lyricsExport(int trackId) => '/api/lyrics/$trackId/export';
  
  // Metadata endpoints
  static String metadataExtract(int trackId) => '/api/metadata/$trackId';
  
  // Recommendation endpoints
  static const String recommendations = '/api/recommendations/';
  
  // Remix endpoints
  static String remixTrack(int trackId) => '/api/remix/$trackId';
  
  // Stem endpoints
  static String stemExtract(int trackId) => '/api/stems/$trackId';
  static String stemExtractSections(int trackId) => '/api/stems/$trackId/sections';
  
  // Sync endpoints
  //update these endpoints
  static const String syncState = '/api/sync/state';
  static const String updatePlaybackState = '/api/sync/state';
  static const String getPlaybackState = '/api/sync/state';
  
  // Tags endpoints
  static String tagsAdd(int trackId) => '/api/tags/$trackId';
  static String tagsGenerate(int trackId) => '/api/tags/generate/$trackId';
  
  // Headers
  static const String contentTypeJson = 'application/json';
  static const String contentTypeMultipart = 'multipart/form-data';
  static const String authorization = 'Authorization';
  static String bearerToken(String token) => 'Bearer $token';
}
