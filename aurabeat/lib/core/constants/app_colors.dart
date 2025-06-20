// // import 'package:flutter/material.dart';

// // class AppColors {
// //   static const Color primary = Color(0xFF6B46C1);
// //   static const Color primaryLight = Color(0xFF8B5CF6);
// //   static const Color primaryDark = Color(0xFF553C9A);
  
// //   static const Color secondary = Color(0xFF10B981);
// //   static const Color secondaryLight = Color(0xFF34D399);
// //   static const Color secondaryDark = Color(0xFF059669);
  
// //   static const Color background = Color(0xFF1F2937);
// //   static const Color surface = Color(0xFF374151);
// //   static const Color surfaceLight = Color(0xFF4B5563);
  
// //   static const Color textPrimary = Color(0xFFFFFFFF);
// //   static const Color textSecondary = Color(0xFFD1D5DB);
// //   static const Color textTertiary = Color(0xFF9CA3AF);
  
// //   static const Color error = Color(0xFFEF4444);
// //   static const Color warning = Color(0xFFF59E0B);
// //   static const Color success = Color(0xFF10B981);
// //   static const Color info = Color(0xFF3B82F6);
  
// //   static const Color accent = Color(0xFFEC4899);
// //   static const Color accentLight = Color(0xFFF472B6);
  
// //   static const MaterialColor primarySwatch = MaterialColor(
// //     0xFF6B46C1,
// //     <int, Color>{
// //       50: Color(0xFFF5F3FF),
// //       100: Color(0xFFEDE9FE),
// //       200: Color(0xFFDDD6FE),
// //       300: Color(0xFFC4B5FD),
// //       400: Color(0xFFA78BFA),
// //       500: Color(0xFF8B5CF6),
// //       600: Color(0xFF7C3AED),
// //       700: Color(0xFF6D28D9),
// //       800: Color(0xFF5B21B6),
// //       900: Color(0xFF4C1D95),
// //     },
// //   );
// // }


// import 'package:flutter/material.dart';

// class AppColors {
  
//   /////////
//   static const Color inactive = Color(0xFF6B46C1);
//   static const Color primary = Color(0xFF6B46C1);
//   static const Color primaryLight = Color(0xFF8B5CF6);
//   static const Color primaryDark = Color(0xFF553C9A);

//   static const Color secondary = Color(0xFF10B981);
//   static const Color secondaryLight = Color(0xFF34D399);
//   static const Color secondaryDark = Color(0xFF059669);

//   static const Color background = Color(0xFF1F2937);
//   static const Color surface = Color(0xFF374151);
//   static const Color surfaceLight = Color(0xFF4B5563);

//   static const Color text = Color(0xFFFFFFFF);
//   static const Color textPrimary = Color(0xFFFFFFFF);
//   static const Color textSecondary = Color(0xFFD1D5DB);
//   static const Color textTertiary = Color(0xFF9CA3AF);

//   static const Color error = Color(0xFFEF4444);
//   static const Color warning = Color(0xFFF59E0B);
//   static const Color success = Color(0xFF10B981);
//   static const Color info = Color(0xFF3B82F6);

//   static const Color accent = Color(0xFFEC4899);
//   static const Color accentLight = Color(0xFFF472B6);

//   // Aliases for missing colors your code expects:
//   static const Color primaryColor = primary;
//   static const Color accentColor = accent;
//   static const Color errorColor = error;
//   static const Color surfaceColor = surface;
//   static const Color backgroundColor = background;

//   static const MaterialColor primarySwatch = MaterialColor(
//     0xFF6B46C1,
//     <int, Color>{
//       50: Color(0xFFF5F3FF),
//       100: Color(0xFFEDE9FE),
//       200: Color(0xFFDDD6FE),
//       300: Color(0xFFC4B5FD),
//       400: Color(0xFFA78BFA),
//       500: Color(0xFF8B5CF6),
//       600: Color(0xFF7C3AED),
//       700: Color(0xFF6D28D9),
//       800: Color(0xFF5B21B6),
//       900: Color(0xFF4C1D95),
//     },
//   );

//   /// Returns the color for [shade] from primarySwatch or default primary color
//   static Color getPrimarySwatchColor(int shade) {
//     return primarySwatch[shade] ?? primary;
//   }
// }


import 'package:flutter/material.dart';

class AppColors {
  static const Color inactive = Color(0xFF6B46C1);
  static const Color primary = Color(0xFF6B46C1);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF553C9A);

  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);

  static const Color background = Color(0xFF1F2937);
  static const Color surface = Color(0xFF374151);
  static const Color surfaceLight = Color(0xFF4B5563);

  static const Color text = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD1D5DB);
  static const Color textTertiary = Color(0xFF9CA3AF);

  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF3B82F6);

  static const Color accent = Color(0xFFEC4899);
  static const Color accentLight = Color(0xFFF472B6);

  // Aliases and missing fields
  static const Color primaryColor = primary;
  static const Color accentColor = accent;
  static const Color errorColor = error;
  static const Color surfaceColor = surface;
  static const Color backgroundColor = background;

  static const Color cardColor = Color(0xFF2C2C2E);
  static const Color borderColor = Color(0xFF4A4A4A);
  static const Color cardBackground = Color(0xFF3A3A3C);
  static const Color border = Color(0xFF5C5C5C);

  // Stem-specific colors
  static const Color vocals = Colors.pink;
  static const Color drums = Colors.orange;
  static const Color bass = Colors.teal;
  static const Color other = Colors.indigo;
  static const Color piano = Colors.brown;
  static const Color guitar = Colors.green;
  static const Color defaultStem = Colors.grey;

  // Gradient background
  static const Color backgroundGradientStart = Color(0xFF1F2937);
  static const Color backgroundGradientEnd = Color(0xFF111827);

  static const MaterialColor primarySwatch = MaterialColor(
    0xFF6B46C1,
    <int, Color>{
      50: Color(0xFFF5F3FF),
      100: Color(0xFFEDE9FE),
      200: Color(0xFFDDD6FE),
      300: Color(0xFFC4B5FD),
      400: Color(0xFFA78BFA),
      500: Color(0xFF8B5CF6),
      600: Color(0xFF7C3AED),
      700: Color(0xFF6D28D9),
      800: Color(0xFF5B21B6),
      900: Color(0xFF4C1D95),
    },
  );

  static Color getPrimarySwatchColor(int shade) {
    return primarySwatch[shade] ?? primary;
  }
}
