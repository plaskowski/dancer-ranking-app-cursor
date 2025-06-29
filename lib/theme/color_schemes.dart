import 'package:flutter/material.dart';

/// Material 3 color schemes for the Dancer Ranking app
/// Based on Material Design 3 color system with custom dance-themed colors

// Light theme color scheme
const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary colors - Blue theme for main actions
  primary: Color(0xFF1976D2), // Material Blue 700
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE3F2FD), // Material Blue 50
  onPrimaryContainer: Color(0xFF0D47A1), // Material Blue 900

  // Secondary colors - Purple theme for dance-related features
  secondary: Color(0xFF7B1FA2), // Material Purple 700
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFF3E5F5), // Material Purple 50
  onSecondaryContainer: Color(0xFF4A148C), // Material Purple 900

  // Tertiary colors - Teal theme for accents
  tertiary: Color(0xFF00796B), // Material Teal 700
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFE0F2F1), // Material Teal 50
  onTertiaryContainer: Color(0xFF004D40), // Material Teal 900

  // Error colors
  error: Color(0xFFD32F2F), // Material Red 700
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFEBEE), // Material Red 50
  onErrorContainer: Color(0xFFB71C1C), // Material Red 900

  // Surface colors
  surface: Color(0xFFFFFBFE),
  onSurface: Color(0xFF1C1B1F),
  surfaceContainerHighest: Color(0xFFE6E0E9),
  surfaceContainerHigh: Color(0xFFECE6F0),
  surfaceContainer: Color(0xFFF3EDF7),
  surfaceContainerLow: Color(0xFFF7F2FA),
  surfaceContainerLowest: Color(0xFFFFFFFF),
  onSurfaceVariant: Color(0xFF49454F),

  // Outline colors
  outline: Color(0xFF79747E),
  outlineVariant: Color(0xFFCAC4D0),

  // Other colors
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF313033),
  onInverseSurface: Color(0xFFF4EFF4),
  inversePrimary: Color(0xFFBB86FC),
  surfaceTint: Color(0xFF1976D2),
);

// Dark theme color scheme
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Primary colors - Blue theme for main actions
  primary: Color(0xFF90CAF9), // Material Blue 200
  onPrimary: Color(0xFF0D47A1), // Material Blue 900
  primaryContainer: Color(0xFF1565C0), // Material Blue 800
  onPrimaryContainer: Color(0xFFE3F2FD), // Material Blue 50

  // Secondary colors - Purple theme for dance-related features
  secondary: Color(0xFFCE93D8), // Material Purple 200
  onSecondary: Color(0xFF4A148C), // Material Purple 900
  secondaryContainer: Color(0xFF6A1B9A), // Material Purple 800
  onSecondaryContainer: Color(0xFFF3E5F5), // Material Purple 50

  // Tertiary colors - Teal theme for accents
  tertiary: Color(0xFF80CBC4), // Material Teal 200
  onTertiary: Color(0xFF004D40), // Material Teal 900
  tertiaryContainer: Color(0xFF00695C), // Material Teal 800
  onTertiaryContainer: Color(0xFFE0F2F1), // Material Teal 50

  // Error colors
  error: Color(0xFFEF5350), // Material Red 400
  onError: Color(0xFFB71C1C), // Material Red 900
  errorContainer: Color(0xFFD32F2F), // Material Red 700
  onErrorContainer: Color(0xFFFFEBEE), // Material Red 50

  // Surface colors
  surface: Color(0xFF1C1B1F),
  onSurface: Color(0xFFE6E0E9),
  surfaceContainerHighest: Color(0xFF36343B),
  surfaceContainerHigh: Color(0xFF2B2930),
  surfaceContainer: Color(0xFF211F26),
  surfaceContainerLow: Color(0xFF1C1B1F),
  surfaceContainerLowest: Color(0xFF0F0E13),
  onSurfaceVariant: Color(0xFFCAC4D0),

  // Outline colors
  outline: Color(0xFF938F99),
  outlineVariant: Color(0xFF49454F),

  // Other colors
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE6E0E9),
  onInverseSurface: Color(0xFF313033),
  inversePrimary: Color(0xFF1976D2),
  surfaceTint: Color(0xFF90CAF9),
);

/// Semantic color mappings for app-specific use cases
class AppSemanticColors {
  // Success colors (for confirmations, completions)
  static const Color successLight = Color(0xFF388E3C); // Material Green 700
  static const Color successDark = Color(0xFF81C784); // Material Green 300
  static const Color successContainerLight =
      Color(0xFFE8F5E8); // Material Green 50
  static const Color successContainerDark =
      Color(0xFF2E7D32); // Material Green 800

  // Warning colors (for alerts, cautions)
  static const Color warningLight = Color(0xFFF57C00); // Material Orange 700
  static const Color warningDark = Color(0xFFFFB74D); // Material Orange 300
  static const Color warningContainerLight =
      Color(0xFFFFF3E0); // Material Orange 50
  static const Color warningContainerDark =
      Color(0xFFE65100); // Material Orange 900

  // Dance-specific colors
  static const Color danceAccentLight =
      Color(0xFF7B1FA2); // Material Purple 700
  static const Color danceAccentDark = Color(0xFFCE93D8); // Material Purple 200

  // Ranking colors
  static const Color rankingHighLight = Color(0xFF1976D2); // Material Blue 700
  static const Color rankingHighDark = Color(0xFF90CAF9); // Material Blue 200
  static const Color rankingNeutralLight =
      Color(0xFF616161); // Material Grey 700
  static const Color rankingNeutralDark =
      Color(0xFFBDBDBD); // Material Grey 400

  // Attendance colors
  static const Color presentLight = Color(0xFF388E3C); // Material Green 700
  static const Color presentDark = Color(0xFF81C784); // Material Green 300
  static const Color absentLight = Color(0xFFD32F2F); // Material Red 700
  static const Color absentDark = Color(0xFFEF5350); // Material Red 400
}
