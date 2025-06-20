// import 'package:flutter/material.dart';
// import 'package:aurabeat/screens/auth/login_screen.dart';
// import 'package:aurabeat/screens/auth/register_screen.dart';
// import 'package:aurabeat/screens/home/home_screen.dart';
// import 'package:aurabeat/screens/upload/upload_screen.dart';
// import 'package:aurabeat/screens/auragen/auragen_screen.dart';
// import 'package:aurabeat/screens/lyrics/lyrics_screen.dart';
// import 'package:aurabeat/screens/lyrics/lyrics_edit_screen.dart';
// import 'package:aurabeat/screens/remix/remix_screen.dart';
// import 'package:aurabeat/screens/stem/stem_screen.dart';
// import 'package:aurabeat/screens/sync/sync_screen.dart';
// import 'package:aurabeat/screens/analytics/analytics_screen.dart';

// // import 'package:flutter/material.dart';
// // import 'package:aurabeat/screens/auth/login_screen.dart';
// // //import '../screens/auth/login_screen.dart';
// // import 'package:aurabeat/screens/auth/register_screen.dart';
// // //import '../screens/auth/register_screen.dart';
// // import '../screens/home/home_screen.dart';
// // import '../screens/upload/upload_screen.dart';
// // import '../screens/auragen/auragen_screen.dart';
// // import '../screens/lyrics/lyrics_screen.dart';
// // import '../screens/lyrics/lyrics_edit_screen.dart';
// // import '../screens/remix/remix_screen.dart';
// // import '../screens/stem/stem_screen.dart';
// // import '../screens/sync/sync_screen.dart';
// // import '../screens/analytics/analytics_screen.dart';

// class AppRoutes {
//   // Route names as constants
//   static const String splash = '/';
//   static const String login = '/login';
//   static const String register = '/register';
//   static const String home = '/home';
//   static const String upload = '/upload';
//   static const String auragen = '/auragen';
//   static const String lyrics = '/lyrics';
//   static const String lyricsEdit = '/lyrics/edit';
//   static const String remix = '/remix';
//   static const String stem = '/stem';
//   static const String sync = '/sync';
//   static const String analytics = '/analytics';

//   // Initial route
//   static const String initial = splash;

//   // Route generator
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case splash:
//         return MaterialPageRoute(
//           builder: (_) => const SplashScreen(),
//           settings: settings,
//         );

//       case login:
//         return MaterialPageRoute(
//           builder: (_) => const LoginScreen(),
//           settings: settings,
//         );

//       case register:
//         return MaterialPageRoute(
//           builder: (_) => const RegisterScreen(),
//           settings: settings,
//         );

//       case home:
//         return MaterialPageRoute(
//           builder: (_) => const HomeScreen(),
//           settings: settings,
//         );

//       case upload:
//         return MaterialPageRoute(
//           builder: (_) => const UploadScreen(),
//           settings: settings,
//         );

//       case auragen:
//         return MaterialPageRoute(
//           builder: (_) => const AuraGenScreen(),
//           settings: settings,
//         );

//       case lyrics:
//         final args = settings.arguments as Map<String, dynamic>?;
//         final trackId = args?['trackId'] as int?;
//         return MaterialPageRoute(
//           builder: (_) => LyricsScreen(trackId: trackId),
//           settings: settings,
//         );

//       case lyricsEdit:
//         final args = settings.arguments as Map<String, dynamic>?;
//         final trackId = args?['trackId'] as int?;
//         final currentLyrics = args?['currentLyrics'] as String?;
//         return MaterialPageRoute(
//           builder: (_) => LyricsEditScreen(
//             trackId: trackId,
//             currentLyrics: currentLyrics,
//           ),
//           settings: settings,
//         );

//       case remix:
//         final args = settings.arguments as Map<String, dynamic>?;
//         final trackId = args?['trackId'] as int?;
//         return MaterialPageRoute(
//           builder: (_) => RemixScreen(trackId: trackId),
//           settings: settings,
//         );

//       case stem:
//         final args = settings.arguments as Map<String, dynamic>?;
//         final trackId = args?['trackId'] as int?;
//         return MaterialPageRoute(
//           builder: (_) => StemScreen(trackId: trackId),
//           settings: settings,
//         );

//       case sync:
//         return MaterialPageRoute(
//           builder: (_) => const SyncScreen(),
//           settings: settings,
//         );

//       case analytics:
//         return MaterialPageRoute(
//           builder: (_) => const AnalyticsScreen(),
//           settings: settings,
//         );

//       default:
//         return _errorRoute(settings.name);
//     }
//   }

//   // Error route for undefined routes
//   static Route<dynamic> _errorRoute(String? routeName) {
//     return MaterialPageRoute(
//       builder: (_) => Scaffold(
//         appBar: AppBar(
//           title: const Text('Error'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.error_outline,
//                 size: 64,
//                 color: Colors.red,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Route not found',
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 routeName ?? 'Unknown route',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(_).pushNamedAndRemoveUntil(
//                     AppRoutes.home,
//                     (route) => false,
//                   );
//                 },
//                 child: const Text('Go to Home'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Navigation helper methods
//   static Future<dynamic> pushNamed(
//     BuildContext context,
//     String routeName, {
//     Object? arguments,
//   }) {
//     return Navigator.of(context).pushNamed(routeName, arguments: arguments);
//   }

//   static Future<dynamic> pushReplacementNamed(
//     BuildContext context,
//     String routeName, {
//     Object? arguments,
//   }) {
//     return Navigator.of(context)
//         .pushReplacementNamed(routeName, arguments: arguments);
//   }

//   static Future<dynamic> pushNamedAndRemoveUntil(
//     BuildContext context,
//     String routeName,
//     bool Function(Route<dynamic>) predicate, {
//     Object? arguments,
//   }) {
//     return Navigator.of(context).pushNamedAndRemoveUntil(
//       routeName,
//       predicate,
//       arguments: arguments,
//     );
//   }

//   static void pop(BuildContext context, [dynamic result]) {
//     Navigator.of(context).pop(result);
//   }

//   static bool canPop(BuildContext context) {
//     return Navigator.of(context).canPop();
//   }

//   // Route validation
//   static bool isValidRoute(String routeName) {
//     return [
//       splash,
//       login,
//       register,
//       home,
//       upload,
//       auragen,
//       lyrics,
//       lyricsEdit,
//       remix,
//       stem,
//       sync,
//       analytics,
//     ].contains(routeName);
//   }

//   // Get all available routes
//   static List<String> getAllRoutes() {
//     return [
//       splash,
//       login,
//       register,
//       home,
//       upload,
//       auragen,
//       lyrics,
//       lyricsEdit,
//       remix,
//       stem,
//       sync,
//       analytics,
//     ];
//   }
// }

// // Splash screen placeholder (you might want to create this in a separate file)
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.music_note,
//               size: 100,
//               color: Colors.blue,
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Music App',
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Route arguments helper class
// class RouteArguments {
//   // Lyrics screen arguments
//   static Map<String, dynamic> lyricsArgs({
//     required int trackId,
//   }) {
//     return {
//       'trackId': trackId,
//     };
//   }

//   // Lyrics edit screen arguments
//   static Map<String, dynamic> lyricsEditArgs({
//     required int trackId,
//     String? currentLyrics,
//   }) {
//     return {
//       'trackId': trackId,
//       'currentLyrics': currentLyrics,
//     };
//   }

//   // Remix screen arguments
//   static Map<String, dynamic> remixArgs({
//     required int trackId,
//   }) {
//     return {
//       'trackId': trackId,
//     };
//   }

//   // Stem screen arguments
//   static Map<String, dynamic> stemArgs({
//     required int trackId,
//   }) {
//     return {
//       'trackId': trackId,
//     };
//   }
// }

// // Route transitions
// class RouteTransitions {
//   static Route<T> slideTransition<T extends Object?>(
//     Widget child,
//     RouteSettings settings, {
//     Offset begin = const Offset(1.0, 0.0),
//     Offset end = Offset.zero,
//     Duration duration = const Duration(milliseconds: 300),
//   }) {
//     return PageRouteBuilder<T>(
//       settings: settings,
//       pageBuilder: (context, animation, secondaryAnimation) => child,
//       transitionDuration: duration,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         var tween = Tween(begin: begin, end: end);
//         var offsetAnimation = animation.drive(tween);
//         return SlideTransition(position: offsetAnimation, child: child);
//       },
//     );
//   }

//   static Route<T> fadeTransition<T extends Object?>(
//     Widget child,
//     RouteSettings settings, {
//     Duration duration = const Duration(milliseconds: 300),
//   }) {
//     return PageRouteBuilder<T>(
//       settings: settings,
//       pageBuilder: (context, animation, secondaryAnimation) => child,
//       transitionDuration: duration,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(opacity: animation, child: child);
//       },
//     );
//   }

//   static Route<T> scaleTransition<T extends Object?>(
//     Widget child,
//     RouteSettings settings, {
//     Duration duration = const Duration(milliseconds: 300),
//   }) {
//     return PageRouteBuilder<T>(
//       settings: settings,
//       pageBuilder: (context, animation, secondaryAnimation) => child,
//       transitionDuration: duration,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         var tween = Tween(begin: 0.0, end: 1.0);
//         var scaleAnimation = animation.drive(tween);
//         return ScaleTransition(scale: scaleAnimation, child: child);
//       },
//     );
//   }
// }

//**********version 2 **************//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aurabeat/screens/auth/login_screen.dart';
import 'package:aurabeat/screens/auth/register_screen.dart';
import 'package:aurabeat/screens/home/home_screen.dart';
import 'package:aurabeat/screens/upload/upload_screen.dart';
import 'package:aurabeat/screens/auragen/auragen_screen.dart';
import 'package:aurabeat/screens/lyrics/lyrics_screen.dart';
import 'package:aurabeat/screens/lyrics/lyrics_edit_screen.dart';
import 'package:aurabeat/screens/remix/remix_screen.dart';
import 'package:aurabeat/screens/stem/stem_screen.dart';
import 'package:aurabeat/screens/sync/sync_screen.dart';
import 'package:aurabeat/screens/analytics/analytics_screen.dart';

class AppRoutes {
  // Route names as constants
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String upload = '/upload';
  static const String auragen = '/auragen';
  static const String lyrics = '/lyrics';
  static const String lyricsEdit = '/lyrics/edit';
  static const String remix = '/remix';
  static const String stem = '/stem';
  static const String sync = '/sync';
  static const String analytics = '/analytics';

  // Initial route
  static const String initial = splash;

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: upload,
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: auragen,
        builder: (context, state) => const AuraGenScreen(),
      ),
      GoRoute(
        path: lyrics,
        builder: (context, state) {
          final trackId = state.uri.queryParameters['trackId'];
          return LyricsScreen(trackId: trackId);
        },
      ),
      GoRoute(
        path: lyricsEdit,
        builder: (context, state) {
          final trackId = state.uri.queryParameters['trackId'];
          final currentLyrics = state.uri.queryParameters['currentLyrics'];
          return LyricsEditScreen(
            trackId: trackId,
            currentLyrics: currentLyrics,
          );
        },
      ),
      GoRoute(
        path: remix,
        builder: (context, state) {
          final trackId = state.uri.queryParameters['trackId'];
          return RemixScreen(trackId: trackId);
        },
      ),
      GoRoute(
        path: stem,
        builder: (context, state) {
          final trackId = state.uri.queryParameters['trackId'];
          return StemScreen(trackId: trackId);
        },
      ),
      GoRoute(
        path: sync,
        builder: (context, state) => const SyncScreen(),
      ),
      GoRoute(
        path: analytics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error.toString()),
  );

  // Route generator (keeping for backward compatibility if needed)
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case upload:
        return MaterialPageRoute(
          builder: (_) => const UploadScreen(),
          settings: settings,
        );

      case auragen:
        return MaterialPageRoute(
          builder: (_) => const AuraGenScreen(),
          settings: settings,
        );

      case lyrics:
        final args = settings.arguments as Map<String, dynamic>?;
        final trackId = args?['trackId']?.toString(); // Convert to String
        return MaterialPageRoute(
          builder: (_) => LyricsScreen(trackId: trackId),
          settings: settings,
        );

      case lyricsEdit:
        final args = settings.arguments as Map<String, dynamic>?;
        final trackId = args?['trackId']?.toString(); // Convert to String
        final currentLyrics = args?['currentLyrics'] as String?;
        return MaterialPageRoute(
          builder: (_) => LyricsEditScreen(
            trackId: trackId,
            currentLyrics: currentLyrics,
          ),
          settings: settings,
        );

      case remix:
        final args = settings.arguments as Map<String, dynamic>?;
        final trackId = args?['trackId']?.toString(); // Convert to String
        return MaterialPageRoute(
          builder: (_) => RemixScreen(trackId: trackId),
          settings: settings,
        );

      case stem:
        final args = settings.arguments as Map<String, dynamic>?;
        final trackId = args?['trackId']?.toString(); // Convert to String
        return MaterialPageRoute(
          builder: (_) => StemScreen(trackId: trackId),
          settings: settings,
        );

      case sync:
        return MaterialPageRoute(
          builder: (_) => const SyncScreen(),
          settings: settings,
        );

      case analytics:
        return MaterialPageRoute(
          builder: (_) => const AnalyticsScreen(),
          settings: settings,
        );

      default:
        return _errorRoute(settings.name);
    }
  }

  // Error route for undefined routes
  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (context) => ErrorScreen(error: 'Route not found: ${routeName ?? 'Unknown route'}'),
    );
  }

  // Navigation helper methods
  static Future<dynamic> pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
    BuildContext context,
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  // Route validation
  static bool isValidRoute(String routeName) {
    return [
      splash,
      login,
      register,
      home,
      upload,
      auragen,
      lyrics,
      lyricsEdit,
      remix,
      stem,
      sync,
      analytics,
    ].contains(routeName);
  }

  // Get all available routes
  static List<String> getAllRoutes() {
    return [
      splash,
      login,
      register,
      home,
      upload,
      auragen,
      lyrics,
      lyricsEdit,
      remix,
      stem,
      sync,
      analytics,
    ];
  }
}

// Error screen widget
class ErrorScreen extends StatelessWidget {
  final String error;
  
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Route not found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                );
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// Splash screen placeholder
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.music_note,
//               size: 100,
//               color: Colors.blue,
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'AuraBeat',
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simulate loading or checking auth status
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go(AppRoutes.login); // or AppRoutes.register if desired
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.music_note,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              'AuraBeat',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}


// Route arguments helper class
class RouteArguments {
  // Lyrics screen arguments
  static Map<String, dynamic> lyricsArgs({
    required String trackId,
  }) {
    return {
      'trackId': trackId,
    };
  }

  // Lyrics edit screen arguments
  static Map<String, dynamic> lyricsEditArgs({
    required String trackId,
    String? currentLyrics,
  }) {
    return {
      'trackId': trackId,
      'currentLyrics': currentLyrics,
    };
  }

  // Remix screen arguments
  static Map<String, dynamic> remixArgs({
    required String trackId,
  }) {
    return {
      'trackId': trackId,
    };
  }

  // Stem screen arguments
  static Map<String, dynamic> stemArgs({
    required String trackId,
  }) {
    return {
      'trackId': trackId,
    };
  }
}

// Route transitions
class RouteTransitions {
  static Route<T> slideTransition<T extends Object?>(
    Widget child,
    RouteSettings settings, {
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static Route<T> fadeTransition<T extends Object?>(
    Widget child,
    RouteSettings settings, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<T> scaleTransition<T extends Object?>(
    Widget child,
    RouteSettings settings, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.0, end: 1.0);
        var scaleAnimation = animation.drive(tween);
        return ScaleTransition(scale: scaleAnimation, child: child);
      },
    );
  }
}