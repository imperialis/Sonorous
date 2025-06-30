import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/track_provider.dart';
import 'providers/lyrics_provider.dart';
import 'providers/analytics_provider.dart';
import 'providers/remix_provider.dart';
import 'providers/stem_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/tags_provider.dart';
import 'providers/player_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TrackProvider()),
        ChangeNotifierProvider(create: (_) => LyricsProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => RemixProvider()),
        ChangeNotifierProvider(create: (_) => StemProvider()),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
        ChangeNotifierProvider(create: (_) => TagsProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: const MusicApp(),
    ),
  );
}